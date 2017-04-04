import logging
def use_logging(func):

    def kkk(*args, **kwargs):
        logging.warn("%s is running" % func.__name__)
        return func(*args, **kwargs)
    return kkk

def bar():
    print('i am bar')

bar = use_logging(bar)
bar()
