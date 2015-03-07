#!/usr/bin/python

from evaluator import *
from evaluator.multi import Dolly
from evaluator.utils import setup_logging, Conf, LOG
import argparse, sys, os
import traceback, signal


LOG_FILE='eval.log'

def sigint_handler(signum, frame):
    Evaluator.spin_unlock()
    LOG.info("Interruption signal received. Exiting")
    sys.exit(1)

if __name__ == '__main__':
    argp = argparse.ArgumentParser(description='Test evaluator app')
    argp.add_argument('-c', '--config', type=str, 
        help='Configuration file', required=True)
    argp.add_argument('-i', '--instances', type=int, 
        help='Number of parallel evaluator processes', default=1)
    argp.add_argument('-l', '--log', type=str, 
        help='Log file name (default {})'.format(LOG_FILE), default=LOG_FILE)

    args = argp.parse_args()

    if args.instances < 1:
        LOG.error('{} instances... You think you are that smart?'.format(args.instances))
        sys.exit(1)

    conf = Conf(args.config, optional={'LOG-LEVEL-STDOUT': str, 
        'LOG-LEVEL-FILE': str, 'LOG-FILE-NAME': str, 'WAIT-SECONDS': int})

    setup_logging(stdout_level = conf.get('LOG-LEVEL-STDOUT', 'NOTSET'),
                file_level = conf.get('LOG-LEVEL-FILE', 'NOTSET'),
                file_name = (args.log or conf.get('LOG-FILE-NAME', LOG_FILE)),
                multiprocess = (args.instances > 1))

    try:
        signal.signal(signal.SIGINT, sigint_handler)
        Evaluator.spin_lock() # create the spin lock file
        Dolly().clone(Evaluator, instances=args.instances, 
            conf_json=args.config, wait_seconds=conf.get('WAIT-SECONDS', 60))
    except Exception as err:
        LOG.error('{}\nexiting'.format(str(err)))
        _, _, tb = sys.exc_info()
        LOG.error('Traceback:\n' + '\n'.join(traceback.format_list(traceback.extract_tb(tb))))

