import logging
def use_logging(func):
    def kkk(*args, **kwargs):
        logging.warn("%s is running" % func.__name__)
        return func(*args)
    return kkk

@use_logging
def foo():
    print("i am foo")

@use_logging
def bar():
    print("i am bar")

bar()
foo()
