def memoize(f):
    cache = {}
    def f_memo(n):
        if n not in cache:
            print("calculate fib ", n)
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
    # print(mm_fib(5))
    print(fib(200))
    # for i in range(5):
        # print(m_fib(40))
        # print(fib(5))
        # print(fm_fib(40))
