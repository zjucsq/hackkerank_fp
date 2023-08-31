from functools import cache
import time

def timer(func):
    t1=time.time()
    res = func()
    t2=time.time()
    cost_time = (t2-t1) * 1000 
    print("Time: {} ms".format(cost_time))
    return res

def memoize(f):
    cache = {}
    def f_memo(n):
        if n not in cache:
            cache[n] = f(n)
        return cache[n]
    return f_memo

def fib(n):
    if n <= 1:
        return n
    else:
        return fib(n - 2) + fib(n - 1)
    
fib = memoize(fib)

if __name__ == "__main__":
    print("res:", timer(lambda: fib(45)))
