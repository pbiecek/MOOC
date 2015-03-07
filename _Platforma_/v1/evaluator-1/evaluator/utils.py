import json, logging, tempfile, os, sys
from subprocess import Popen, PIPE
from logging.handlers import RotatingFileHandler
import multiprocessing, signal

LOG = logging.getLogger('evaluator')

def _log_level(level, ltype):
    if level is None:
        return None
    _level = logging._levelNames.get(level)
    if isinstance(_level, int):
        return _level
    elif isinstance(_level, str):
        return level
    else: # if None
        # do not use logging for logging here !!!
        print >>sys.stderr, 'Unknown log level: {}. {} logging disabled'.format(level, ltype)

class MultiRotatingFileHandler(RotatingFileHandler):
    """
    Rotating log file handler multiprocess-safe.
    """
    def __init__(self, *args, **kwargs):
        super(MultiRotatingFileHandler, self).__init__(*args, **kwargs)

    def createLock(self):
        self.lock = multiprocessing.RLock()

class MultiStreamHandler(logging.StreamHandler):
    """
    Stream log handler - multiprocess safe version.
    """
    def __init__(self, *args, **kwargs):
        super(MultiStreamHandler, self).__init__(*args, **kwargs)

    def createLock(self):
        self.lock = multiprocessing.RLock()

def setup_logging(stdout_level=logging.NOTSET, file_level=logging.NOTSET, file_name=None, multiprocess=False):
    """
    Configures file and console logging. 
    """
    logger = logging.getLogger('evaluator')
    logger.setLevel(logging.DEBUG)

    formatter = logging.Formatter('[%(process)d] %(asctime)s - %(filename)s:%(lineno)d - %(levelname)s: %(message)s')

    # log to file
    file_level = _log_level(file_level, 'File')
    if file_level > logging.NOTSET and file_name is not None:
        FileHandlerClass = MultiRotatingFileHandler if multiprocess else RotatingFileHandler
        fhandler = FileHandlerClass(file_name, maxBytes=10 * 1024 * 1024, backupCount=5)
        fhandler.setLevel(file_level)
        fhandler.setFormatter(formatter)
        logger.addHandler(fhandler)
    
    # log to screen
    stdout_level = _log_level(stdout_level, 'Screen')
    if stdout_level > logging.NOTSET:
        StreamHandlerClass = MultiStreamHandler if multiprocess else logging.StreamHandler
        shandler = StreamHandlerClass(sys.stdout)
        shandler.setLevel(stdout_level)
        shandler.setFormatter(formatter)
        logger.addHandler(shandler)

    global LOG
    LOG = logger

class ConfError(Exception):
    pass

class Conf(object):
    """
    Configuration file reader and processor
    """
    def __init__(self, json_conf, required=None, optional=None):
        try:
            with open(json_conf, 'r') as fp:
                self.conf = json.load(fp)
        except Exception as e:
            raise ConfError(str(e))

        self.json_conf = json_conf

        self.process_directives(os.path.dirname(json_conf))
        self.process_params(required)
        self.process_params(optional, False)

    def process_directives(self, basedir='.'):
        inc_conf = {}
        for k in self.conf.keys():
            if k.lower().lstrip().startswith("#include"):
                try:
                    with open(os.path.join(basedir, self.conf[k]), 'r') as fp:
                        conf = json.load(fp)
                        inc_conf.update(conf)
                except Exception as e:
                    raise ConfError('Invalid included config file {}: {}'.format(self.conf[k], str(e)))
        self.conf.update(inc_conf)

    def __iter__(self):
        for k, v in self.conf.items():
            yield (k, v)

    def process_params(self, params, required=True):
        if params:
            for k, v in params.items():
                if not k in self.conf.keys():
                    if required:
                        raise ConfError("Parameter {0} is obligatory in file {1}".format(k, self.json_conf))
                    else:
                        continue
                if hasattr(v, '__call__'):
                    transf = v(self.conf[k])
                    if transf is None:
                        raise ConfError(
                                "Invalid value of config param {0} in file {1}".format(k, self.json_conf))
                    else:
                        self.conf[k] = transf
                else:
                    if not isinstance(self.conf[k], v):
                        raise ConfError(
                                "Invalid param type in file {0}: {1} must be {2}".format(
                                    self.json_conf, k, v.__name__))

    def get(self, key, default=None):
        return self.conf.get(key, default)

    def get_many(self, keys):
        """
        Return multiple keys at once
        """
        return {k: v for k, v in self.conf.items() if k in keys}

    def update(self, kvdict):
        self.conf.update(kvdict)

    def __str__(self):
        return '\n'.join('{0}={1}'.format(k, v) for k, v in self.conf.items())


class FakeLock(object):
    """
    No-op lock. Does not lock anything.
    """
    def __enter__(self):
        pass
    def __exit__(self, *args, **kwargs):
        pass


class TempFile(object):
    """
    Context manager to create and delete temporary named files.
    """
    def __init__(self):
        self.fp = tempfile.NamedTemporaryFile(delete=False)

    def __enter__(self):
        return self.fp

    def __exit__(self, exc, value, tb):
        try:
            self.fp.close()
            os.unlink(self.fp.name)
        except Exception as err:
            LOG.warning('Cannot remove temporary file {}: {}'.format(self.fname, str(err)))

class Timeout(Exception):
    """
    Object of this class is thrown by SIGALRM handler to handle timeouts.
    """
    pass

def timeout_handler(signum, frame):
    raise Timeout()

def timeoutable():
    signal.signal(signal.SIGALRM, timeout_handler)

def set_timeout(timeout_s):
    signal.alarm(timeout_s)

def unset_timeout():
    signal.alarm(0)

