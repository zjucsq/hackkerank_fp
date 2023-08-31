class Input_t:
    def __init__(self, str, idx=0):
        self.str = str
        self.idx = idx

    def get_char(self):
        if self.idx == len(self.str):
            return ''
        return self.str[self.idx]

    def next(self):
        return Input_t(self.str, self.idx + 1)


def p_and(parser1, parser2):
    def new_parser(input):
        r1, i1 = parser1(input)
        if r1 is None:
            return (None, input)
        else:
            r2, i2 = parser2(i1)
            if r2 is None:
                return (None, input)
            else:
                return ((r1, r2), i2)
    return new_parser


def p_or(parser1, parser2):
    def new_parser(input):
        r1, i1 = parser1(input)
        if r1 is not None:
            return (r1, i1)
        else:
            r2, i2 = parser2(input)
            if r2 is not None:
                return (r2, i2)
            else:
                return (None, input)
    return new_parser


def p_many(parser):
    def new_parser(input):
        res = []
        while True:
            r, i = parser(input)
            if r is None:
                return (res, i)
            res.append(r)
            input = i
    return new_parser


def p_many1(parser): return p_and(parser, p_many(parser))


def char_parser(input, c):
    if input.get_char() == c:
        return (c, input.next())
    else:
        return (None, input)


def add_parser(i): return char_parser(i, '+')
def sub_parser(i): return char_parser(i, '-')
def mul_parser(i): return char_parser(i, '*')
def div_parser(i): return char_parser(i, '/')
def lbr_parser(i): return char_parser(i, '(')
def rbr_parser(i): return char_parser(i, ')')


addsub_parser = p_or(add_parser, sub_parser)
muldiv_parser = p_or(mul_parser, div_parser)


def int_parser(input):
    if input.get_char().isdigit():
        res = 0
        while input.get_char().isdigit():
            res = res * 10 + ord(input.get_char()) - ord('0')
            input = input.next()
        return (res, input)
    else:
        return (None, input)


def expr_parser(input):
    r, input_1 = p_and(term_parser, p_many(
        p_and(addsub_parser, term_parser)))(input)
    res, lst = r
    for i in range(len(lst)):
        if lst[i][0] == '+':
            res += lst[i][1]
        else:
            res -= lst[i][1]
    return (res, input_1)


def term_parser(input):
    r, input_1 = p_and(factor_parser, p_many(
        p_and(muldiv_parser, factor_parser)))(input)
    res, lst = r
    for i in range(len(lst)):
        if lst[i][0] == '*':
            res *= lst[i][1]
        else:
            # res //= lst[i][1]
            import math
            res = math.trunc(res / lst[i][1])
    return (res, input_1)


def factor_parser(input):
    r, i = int_parser(input)
    if r is not None:
        return (r, i)
    r, i = addsub_parser(input)
    if r is not None:
        r1, i1 = factor_parser(i)
        if r1 is not None:
            return (r1 if r == '+' else -r1, i1)
    r, i = lbr_parser(input)
    if r is not None:
        r1, i1 = expr_parser(i)
        if r1 is not None:
            r2, i2 = rbr_parser(i1)
            if r2 is not None:
                return (r1, i2)
    return (None, input)


class Solution:
    def calculate(self, s: str) -> int:
        s = s.replace(" ", "")
        input = Input_t(s)
        r, i = expr_parser(input)
        return r


if __name__ == '__main__':
    s = input()
    print(Solution().calculate(s))
