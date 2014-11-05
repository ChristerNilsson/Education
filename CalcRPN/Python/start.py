# https://github.com/ChristerNilsson/Education/blob/master/CalcRPN/Python/start.py

import math
from fractions import gcd


def ass(a, b):
    assert a == b

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


def run(str):
    del s[:]
    calc(str.split())
    return s

ass(2+3, 5)
#ass(2+3, 6)
ass(run('1 2'),[1,2])
#ass(run('1 2 3 dup'), [1,2,3,3])
#ass(run('1 2 3 dup2'),[1,2,3,2,3])
#ass(run('1 2 3 dup3'),[1,2,3,1,2,3])
#ass(run('1 2 3 swp'), [1,3,2])
#ass(run('1 2 3 rdn'), [3,1,2])
#ass(run('1 2 3 rup'), [2,3,1])
#ass(run('1 2 3 rev'), [3,2,1])
#ass(run('1 2 3 drp'), [1,2])
#ass(run('1 2 3 clr'), [])
#
#ass(run('0'),[0])
#ass(run('2'),[2])
#ass(run('2 3 +'),[5])
#ass(run('2 3 -'),[-1])
#ass(run('2 3 4 + *'),[14])
#ass(run('5 2 /'),[2.5])
#ass(run('15 5 xor'),[10])
#ass(run('25 sqrt'),[5])
#
#ass(run('1 5 sqrt + 2 /'),[1.618033988749895]) # golden ratio
#ass(run('2 1 5 sqrt + /'),[0.6180339887498948]) # golden ratio inverted
#
#ass(run('5 sq'),[25])
#
#ass(run('1 usd'),[7.25])
#ass(run('2 eur'),[19])
#ass(run('1 usd 2 eur +'),[26.25])
#ass(run('1 usd_eur'),[0.763157894736842]) # OBS!
#ass(run('2 eur_usd'),[2.6206896551724137])
#
#ass(run('3 4 hypotenusa'), [5.0])
#
#ass(run('pi 2 / @pihalva'), [])
#ass(run('pihalva'), [1.5707963267948966])  # OBS!
#
#ass(run('1 2 4 nim1'), [6,5,3])
#ass(run('1 2 4 nim2'), [0,0,1])
#
#ass(run('5 fact'), [120])
#
#ass(run('100 sum'), [5050])
#ass(run('2 sum'), [3])
#ass(run('1 sum'), [1])
#ass(run('0 sum'), [0])
#
#ass(run('1 fib'), [1])
#ass(run('2 fib'), [2])
#ass(run('3 fib'), [3])
#ass(run('4 fib'), [5])
#ass(run('10 fib'), [89])
#ass(run('1 1 10 fibq'),[89.0, 144.0, 0.0])
#ass(run('1 1 20 fibq'),[10946.0, 17711.0, 0.0])
#ass(run('1 1 36 fibq'),[24157817.0, 39088169.0, 0.0])
#
#ass(prime(11), True)
#ass(prime(12), False)
#ass(run('11 prime'), [True])
#ass(run('12 prime'), [False])
#ass(gcd(12,15), 3)  # OBS
#ass(run('12 15 gcd'), [3])
#ass(lcm(12,15), 60)  # OBS
#ass(run('12 15 lcm'), [60])
#
#ass(run('255 hex'), ['0xff'])
#ass(run('hex ff dec'), [255])
#ass(run('15 bin'), ['0b1111'])
#ass(run('111 bin 111 oct 111 hex 111 + + + dec'), [464])
#ass(run('3405691582 hex'), ['0xcafebabe'])
#
#ass(run('12 13 serie'), [25])
#ass(run('2.0 5.0 para'), [1.4285714285714286])
#ass(run('2.0 5.0 para 12 serie'), [13.428571428571429])
## https://www.wisc-online.com/learn/career-clusters/stem/dce3202/series-parallel-resistance--practice-problems
#
#ass(run('100 1 iter'),[100, 10])
#ass(run('1000 1 iter'),[1000, 31.622776601684336])
#
#ass(run('25 20 zero'),[31.62277660168379, -8.881784197001252e-15])
#
#ass(run('1 1 gr'),[24157817.0, 39088169.0])

s = []
calc(['?'])
while True:
    calc(raw_input(str(s) + ' Command: ').split())