from multiprocessing import Process, Lock
import time

class DollyError(Exception):
    pass

class Dolly(object):
    """
    Cloned class's __init__ must accept kwarg 'lock' and all other params 
    are optional, but must be passed in as kwargs.
    lock will be None if no contention
    The cloned class must be callable - implement __call__ with no arguments

    example:
        class Proc(object):
            def __init__(self, lock=None, **kwargs):
                self.lock = lock
            def __call__(self, *args, **kwargs):
                # do something safe
                with self.lock:
                    pass # now secured with lock
                # and the rest
    """
    def clone(self, Class, instances=1, **class_init_kwargs):
        if instances == 1:
            Class(lock=None, **class_init_kwargs)()
        else:
            lock = Lock() 
            children = [Process(target=Class(lock = lock, **class_init_kwargs)) 
                for pi in range(instances)]
            for child in children:
                child.start()
            for child in children:
                child.join()


