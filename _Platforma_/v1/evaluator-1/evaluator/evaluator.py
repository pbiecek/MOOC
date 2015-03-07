# -*- coding: utf8 -*-

from db import DB
from utils import *
from subprocess import Popen, PIPE
import shlex
import os, time
from datetime import datetime
import hashlib


class R(object):

    class AppArmor(object):
        """
        Read in the configuration file (json) and generate R code with appropriate calls to apparmor.
        Once the object is instantiated, it can be converted into script by calling unicode on it.
        """
        def __init__(self, profile, limits = {}):
            self.profile = profile
            self.limits = limits

        @staticmethod
        def from_json(conf_json):
            profile = {'AA-PROFILE': str}
            limits = {'RLIMIT_AS': int, 'RLIMIT_CORE': int, 'RLIMIT_DATA': int, 'RLIMIT_FSIZE': int,
                    'RLIMIT_NOFILE': int, 'RLIMIT_NPROC': int, 'RLIMIT_STACK': int, 'RLIMIT_CPU': int,
                    'RLIMIT_MSGQUEUE': int, 'RLIMIT_RTPRIO': int, 'RLIMIT_SIGPENDING': int,
                    'RLIMIT_DATA': int, 'RLIMIT_MEMLOCK': int, 'RLIMIT_NICE': int, 'RLIMIT_RTTIME': int}

            conf = Conf(conf_json, optional=dict(profile.items() + limits.items()))

            return R.AppArmor(conf.get('AA-PROFILE'), conf.get_many(limits.keys()))

        def __unicode__(self):
            return """
                library(RAppArmor)
                {profile}
                {limits}
            """.format(
                    profile = "aa_change_profile('{}')".format(self.profile) if self.profile else '', 
                    limits = '\n'.join(['{}({})'.format(key.lower(), self.limits[key]) for key in self.limits.keys()])
                )

    R_CMD = 'R --no-save -f {infile}'

    R_SEP = hashlib.sha1(__file__).hexdigest()

    # NOTE: curly brackets are doubled as that's the way to escape them in format string
    R_FENCED_CODE = """
        setwd(tempdir())
        {app_armor}
        print_result <- function(results) {{
            write('{rsep}\\n', stderr())
            for (res in results)
                write(res, stderr())
            write('{rsep}\\n', stderr())
        }}

        tryCatch({{
                {submitted_code}
                {eval_code} # assume 'isCorrect' FALSE/TRUE and if FALSE then message in 'comments'
            }}, 
            error = function(e) {{exec_error <<- e$message}},
            warning = function (e) {{}}, # suppress warnings
            finally = {{
                if (exists('exec_error')) {{
                    print_result(c('Błąd podczas wykonania programu:', exec_error))
                    quit('no', 1)
                }}

                if (exists('isCorrect')) {{
                    if (isCorrect) quit('no', 0) # all correct
                    else {{
                        print_result(ifelse(exists('comments'), comments, 'To nie jest poprawna odpowiedź'))
                        quit('no', 2)
                    }}
                }}
            }}
        )
    """

class SQL(object):
    """
    All SQL statements that read and manipulate DB objects.
    """
    GET_SUBMISSION = """
        SELECT
            sub.id,
            sub.user_id,
            sub.lesson_id,
            sub.content
        FROM 
            course_submissions sub JOIN (
                SELECT  
                    user_id,
                    lesson_id
                FROM 
                    course_submissions
                WHERE 
                    status = 'new'
                ORDER BY created_at
                LIMIT 1
            ) fsub ON sub.user_id = fsub.user_id AND sub.lesson_id = fsub.lesson_id
        WHERE 
            status = 'new'
        ORDER BY 
            created_at DESC
        LIMIT 1 
    """

    EXPIRE_SUBMISSIONS = """
        UPDATE course_submissions
        SET status = 'expired', updated_at = now()
        WHERE user_id = %s AND lesson_id = %s and id <> %s;
    """

    LOCK_SUBMISSION = """
        UPDATE course_submissions
        SET status = 'pending', updated_at = now()
        WHERE id = %s
    """

    RECLAIM_SUBMISSIONS = """
        UPDATE course_submissions
        SET status = 'expired', updated_at = now()
        WHERE status = 'pending'
            AND updated_at < now() - interval 1 hour`
    """

    GET_EXPECT = """
        SELECT expect FROM course_lessons WHERE id = %s
    """
    
    SET_STATUS = """
        UPDATE course_submissions
        SET status = %s, message = %s, evaluated_at = now(), updated_at = now()
        WHERE id = %s
    """

class EvaluatorError(Exception):
    pass

class Evaluator(object):
    """
    Main evaluator class that runs the whole process.
    """

    STATUS_MAP = {0: 'ok'}
    STATUS_DEFAULT = 'errors'
    
    SPIN_LOCK = '.evaluator-lock'

    def __init__(self, conf_json = None, lock = None, wait_seconds = 60):
        self.db = DB.from_json(conf_json)
        self.aa = R.AppArmor.from_json(conf_json)
        self.timeout = Conf(conf_json, optional={'TIMEOUT': int}).get('TIMEOUT')
        self.lock = lock or FakeLock()
        self.wait_seconds = wait_seconds
        self.last_reclaim = datetime.now()

    def get_submission(self):
        """
        Get one submission to be evaluated. Mark all older submissions from the same user
        for the same lesson as expired. Secure access with lock if in multiprocess mode.
        """
        with self.lock:
            try:
                with self.db as dbconn:
                    nr = dbconn.execute(SQL.GET_SUBMISSION)
                    if nr == 0:
                        return None, None, None, None
                    submission_id, user_id, lesson_id, content = dbconn.fetchone()
                    dbconn.execute(SQL.EXPIRE_SUBMISSIONS, (user_id, lesson_id, submission_id))
                    dbconn.execute(SQL.LOCK_SUBMISSION, (submission_id,))
                    return submission_id, user_id, lesson_id, content.encode('utf8')
            except Exception as err:
                raise EvaluatorError('Cannot evaluate submission: {}'.format(str(err)))

    def get_expect(self, lesson_id):
        """
        Retrieve code used for evaluation of the submitted code for a given lesson.
        """
        try:
            with self.db as dbconn:
                nr = dbconn.execute(SQL.GET_EXPECT, (lesson_id,))
                if nr == 1:
                    (expect,) = dbconn.fetchone()
                    return expect.encode('utf8')
        except Exception as err:
                raise EvaluatorError('Cannot retrieve evaluation code for lesson {}: {}'.format(lesson_id, str(err)))
        
        # should already have returned if all fine
        raise EvaluatorError('No evaluation code found for lesson {}'.format(lesson_id))
            
    def _lines_between(self, buf, sep):
        found = False
        for l in buf.splitlines():
            if l.startswith(sep):
                if found: # already in-between seps
                    return
                found = True
                continue
            if found:
                yield l

    def r_eval(self, content, expect):
        """
        Execute R code in the context of a new spawned process.
        """
        timeoutable()  # listen to SIGALRM
        with TempFile() as fp: # temporary file to write merged script to. Ctx manager will take care of cleanup
            try:
                LOG.debug('Executing R: {}'.format(
                    R.R_FENCED_CODE.format(
                        rsep = R.R_SEP, submitted_code = content, eval_code = expect, app_armor=unicode(self.aa))))
                fp.write(R.R_FENCED_CODE.format(rsep = R.R_SEP, submitted_code = content, eval_code = expect, app_armor = unicode(self.aa)))
                fp.close() # not deleted here, context manager will get the rid of the file after it's evaluated
            except Exception as err:
                raise EvaluatorError('Cannot merge submitted code with evaluator: {}'.format(str(err)))

            cmd = R.R_CMD.format(infile = fp.name)

            p, status, out, err = (None,) * 4
            try:
                if self.timeout:
                    set_timeout(self.timeout) # SIGALRM in ... seconds
                p = Popen(shlex.split(cmd), stdin = PIPE, stdout = PIPE, stderr = PIPE)
                out, err = p.communicate()
                status = p.returncode
                err = '\n'.join([l for l in self._lines_between(err, R.R_SEP)]) 
            except Timeout as err:
                LOG.error('Evaluation took more than {} seconds. Terminating R session'.format(self.timeout))
                status = 1
                err = 'Sesja R trwała dłużej niż {} sekund i została przerwana'.format(self.timeout)
            except Exception as err:
                raise EvaluatorError('Cannot execute command "{}": {}'.format(cmd, str(err)))
            finally:
                if self.timeout:
                    unset_timeout()
                    if p and p.poll() is None:
                        p.kill()
                        p.wait() # collect zombie process

            LOG.debug('R completed with status={}\nOutput={}\nErrors={}'.format(status, out, err))

            return status, out, err

    def set_submission_status(self, submission_id, r_status, message):
        """
        Update submission status in DB.
        """
        try:
            with self.db as dbconn:
                LOG.debug('Setting status of {} to {} ({})'.format(
                    submission_id, Evaluator.STATUS_MAP.get(r_status, Evaluator.STATUS_DEFAULT), message))
                dbconn.execute(SQL.SET_STATUS, (Evaluator.STATUS_MAP.get(r_status, Evaluator.STATUS_DEFAULT), 
                    message, submission_id))
        except Exception as err:
            LOG.error('Failed to set status of submission {} to ({}): {}'.format(
                submission_id, Evaluator.STATUS_MAP.get(r_status, Evaluator.STATUS_DEFAULT), 
                message, str(err)))
            # too bad... try to reset the status back to 'new'
            try:
                with self.db as dbconn:
                    dbconn.execute(SQL.SET_STATUS, ('new', '', submission_id))
            except Exception as err:
                raise EvaluatorError('Cannot reset the state of {} back to new. Submission in inconsistent state!'.format(
                    submission_id))

    def reclaim_submissions(self, timeout = 3600):
        """
        Change the status of pending tasks that remain 'pending' for more than an hour
        to expired.
        """
        tdiff = datetime.now() - self.last_reclaim
        if tdiff.days * 24 * 3600 + tdiff.seconds > timeout:
            with self.lock:
                try:
                    with self.db as dbconn:
                        nr = dbconn.execute(SQL.RECLAIM_SUBMISSIONS)
                except Exception as err:
                    LOG.error('Cannot mark old pending tasks as expired: {}'.format(str(err)))
                else:
                    self.last_reclaim = datetime.now()

    @staticmethod
    def spin_unlock():
        if os.path.exists(Evaluator.SPIN_LOCK):
            os.unlink(Evaluator.SPIN_LOCK)

    @staticmethod
    def spin_lock():
        if os.path.exists(Evaluator.SPIN_LOCK):
            raise EvaluatorError('File {} exists. It may indicate running evaluator. Remove and restart if this is a false alarm'.format(
                Evaluator.SPIN_LOCK))
        else:
            with open(Evaluator.SPIN_LOCK, 'w') as fp:
                fp.write('{}@{}'.format(os.getpid(), datetime.now()))
            LOG.info('Lock file {} created. Program will exit gracefully when lock file is removed'.format(Evaluator.SPIN_LOCK))

    @staticmethod
    def is_spinning():
        return os.path.exists(Evaluator.SPIN_LOCK)

    def start(self):
        """
        Main loop. Will run as long as spin lock file exists. 
        One way to exit gracefully is to remove the file.
        """
        self.db.connect()
        failures, max_failures = 0, 3
        while Evaluator.is_spinning():
            try:
                submission_id, user_id, lesson_id, content = self.get_submission()
                if submission_id is None:
                    LOG.debug('No submissions waiting. Falling asleep for {}'.format(self.wait_seconds))
                    time.sleep(self.wait_seconds)
                    continue
                expect = self.get_expect(lesson_id)
                status, out, err = self.r_eval(content, expect)
                if status is not None:
                    self.set_submission_status(submission_id, status, err)
                self.reclaim_submissions()
                failures = 0
            except Exception as err:
                LOG.error(str(err))
                failures += 1
                if failures >= max_failures:
                    raise EvaluatorError('Failed {} times in a row. Exiting'.format(failures))

    def __call__(self, *args, **kwargs):
        """
        Multiprocessed version needs Evaluator class to be callable.
        """
        self.start()

