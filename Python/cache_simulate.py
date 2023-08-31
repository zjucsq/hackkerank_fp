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
    
def fib_nonrec(fib, n):
    if n <= 1:
        return n
    else:
        return fib(n - 2) + fib(n - 1)
    
# def fib_rec(n):
#     return fib_nonrec(fib, n)

# def make_rec(f_norec):
#     def f(x):
#         return f_norec(f, x)
#     return f

def memo_rec(f_norec, x):
    fref = lambda: print("this function should never be called!")
    f = memoize(lambda x: f_norec(fref, x))
    fref = f
    return f(x)

fib_final = lambda x: memo_rec(fib_nonrec, x)

if __name__ == "__main__":
    # print(mm_fib(5))
    print(fib_final(200))
    # for i in range(5):
        # print(m_fib(40))
        # print(fib(5))
        # print(fm_fib(40))
