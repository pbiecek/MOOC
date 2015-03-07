import MySQLdb
from utils import Conf, LOG

class DBError(Exception):
    pass

class DBFatalError(DBError):
    pass

class DB(object):
    """
    Database connector
    """
    @staticmethod
    def from_json(conf_json):
        conf = Conf(conf_json, required={'DB-HOST': str, 'DB-USER': str, 'DB-PASSWD': str, 'DB-NAME': str})
        return DB(host=conf.get('DB-HOST'), database=conf.get('DB-NAME'),
                    user=conf.get('DB-USER'), password=conf.get('DB-PASSWD'))

    def __init__(self, host=None, port=None, database=None, schema=None, user=None, password=None):
        self.host = host
        self.database = database
        self.user = user
        self.password = password
        self.conn, self.cursor = None, None

    def connect(self, trials = 3):
        for trial in range(trials):
            try:
                self.conn = MySQLdb.connect(host=self.host, db=self.database,
                    user=self.user, passwd=self.password, charset='utf8')
                self.cursor = self.conn.cursor()
                return self
            except Exception as err:
                self.close()
                LOG.error('Cannot connect do db [{}/{}]. Retrying.... Error message was: {}'.format(
                    trial + 1, trials, str(err)))
        raise DBFatalError('Cannot initialize db connection: {}'.format(str(err)))

    def close(self):
        try:
            if self.cursor:
                self.cursor.close()
            if self.conn:
                self.conn.close()
        except Exception as warn:
            # not good, but we do not care that much anymore
            LOG.warning('Issues with shutting down loader db connection: {}'.format(str(err)))

    def execute(self, sql, *args, **kwargs):
        if self.conn is None or self.cursor is None or not self.conn.open:
            self.connect()
        try:
            LOG.debug('DB executing: {}'.format(sql))
            return self.cursor.execute(sql, *args, **kwargs)
        except MySQLdb.OperationalError as err:
            LOG.error('Cannot execute: {}. Renewing connection and re-trying'.format(str(err)))
            self.close()
            self.connect()
            try:
                return self.cursor.execute(sql, *args, **kwargs)
            except Exception as err:
                raise DBFatalError('Cannot execute query: {}'.format(str(err)))

    def commit(self):
        if self.conn:
            return self.conn.commit()
     
    def rollback(self):
        if self.conn:
            return self.conn.rollback()

    def fetchall(self):
        return self.cursor.fetchall()

    def fetchone(self):
        return self.cursor.fetchone()

    def __enter__(self):
        return self

    def __exit__(self, exc, value, traceback):
        if exc:
            self.rollback()
        else:
            self.commit()

if __name__ == '__main__':
    with DB(host='localhost', database='testevaldb', user='testeval', password='testeval') as db:
        db.execute('SELECT * from information_schema')
        print db.fetchone()



