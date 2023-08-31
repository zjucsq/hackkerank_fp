class Solution:
    def calculate(self, s: str) -> int:
        stack_num = []
        stack_opt = []
        priorty = {'(': 0, ')': 0, '+': 1, '-': 1, '*': 2, '/': 2}
        i = 0
        while i < len(s):
            if s[i] == ' ':
                pass
            elif '0' <= s[i] <= '9':
                j = i + 1
                while j < len(s) and '0' <= s[j] <= '9':
                    j += 1
                stack_num.append(int(s[i:j]))
                i = j - 1
            elif s[i] == '(':
                stack_opt.append(s[i])
            elif s[i] == ')':
                while stack_opt[-1] != '(':
                    opt = stack_opt.pop()
                    A = stack_num.pop()
                    B = stack_num.pop()
                    stack_num.append(self.calc(A, B, opt))
                stack_opt.pop()
            else:
                while stack_opt and priorty[stack_opt[-1]] >= priorty[s[i]]:
                    opt = stack_opt.pop()
                    A = stack_num.pop()
                    B = stack_num.pop()
                    stack_num.append(self.calc(A, B, opt))
                stack_opt.append(s[i])
            i += 1
            print(stack_num, stack_opt)

        while stack_opt:
            opt = stack_opt.pop()
            A = stack_num.pop()
            B = stack_num.pop()
            stack_num.append(self.calc(A, B, opt))
        return stack_num[-1]

    def calc(self, a, b, op):
        if op == '+':
            return b + a
        elif op == '-':
            return b - a
        elif op == '*':
            return b * a
        elif op == '/':
            return int(b / a)
