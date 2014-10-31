https://github.com/ChristerNilsson/Education/blob/master/CalcRPN/Python/start.py

s = []

def calc(lst):
    for x in lst:
        if x == '+':
            s.append(s.pop() + s.pop())
        elif x == 'drp':
            s.pop()
        elif x == 'clr':
            del s[:]
        elif x == '?':
            print('? + drp clr q')
        elif x == 'q':
            exit()
        else:
            s.append(float(x))
    if len(s) == 0:
        return None
    else:
        return s[-1]

assert 2+3 == 5
# assert 2+3 == 6

def run(str):
    return calc(str.split())

assert run('2') == 2
assert run('2 3 +') == 5
#assert run('2 3 -') == -1
#assert run('2 3 4 + *') == 14
#assert run('5 2 /') == 2.5
#assert run('15 5 xor') == 10
#assert run('25 sqrt') == 5

#def stk(str):
#    del s[:]
#    calc(str.split())
#    return s
#
#assert stk('1 2') == [1,2]
#assert stk('1 dup') == [1,1]
#assert stk('1 2 3 swp') == [1,3,2]
#assert stk('1 2 3 rdn') == [3,1,2]
#assert stk('1 2 3 rev') == [3,2,1]
#assert stk('1 2 3 drp') == [1,2]
#assert stk('1 2 3 clr') == []

#def stk2(str):
#    del s[:]
#    del e[:]
#    calc(str.split())
#    return [s, e]
#
#assert stk2('1 2 3 push') == [[1,2],[3]]
#assert stk2('1 2 3 push 4 pop') == [[1,2,4,3],[]]

#def dict(str):
#    calc(str.split())
#    return d
#
#assert dict(': sq dup *') == {'sq': ['dup', '*']}
#assert run('5 sq') == 25
#
#assert stk('1 2 4 nim0') == [6,5,3]
#assert stk('1 2 4 nim') == [6,5,3]

s = []
calc(['?'])
while True:
    calc(input(str(s) + ' Command: ').split())