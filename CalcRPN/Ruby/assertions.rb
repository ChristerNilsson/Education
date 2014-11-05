#ass 2+3,5   # Always succeeds.
##ass 2+3,6  # Always fails. Check out the message and the link!
#
#@c.run('2', [2])
#@c.run('1 2', [1,2])
#
## Stack manipulation
#@c.run('1 2 3 dup', [1,2,3,3])
#@c.run('1 2 3 dup2',[1,2,3,2,3])
#@c.run('1 2 3 swp', [1,3,2])
#@c.run('1 2 3 rdn', [3,1,2])
#@c.run('1 2 3 rup', [2,3,1])
#@c.run('1 2 3 rev', [3,2,1])
#@c.run('1 2 3 drp', [1,2])
#
#@c.run('-3 chs', [3])
#@c.run('3 chs', [-3])
#@c.run('1 2 3 clr', [])
#
## No operands
#@c.run('pi', [Math::PI])
#
## One operand
#@c.run('-3 abs', [3])
#@c.run('3 abs', [3])
#@c.run('2 inv', [0.5])
#@c.run('0.25 inv', [4])
#@c.run('pi int',[3])
#@c.run('3 float',[3.0])
#
## Two operands
#@c.run('2 3 +',[5])
#@c.run('2 3 -',[-1])
#@c.run('2 3 4 + *',[14])
#@c.run('5 2 /',[2])
#@c.run('5 2 float /',[2.5])
#@c.run('2 3 **',[8])
#@c.run('3 2 **',[9])
#@c.run('3 2 mod',[1])
#@c.run('2 3 mod',[2])
#
## all words starting with @ should act as "save as"
#@c.run('pi 2 / @pihalf', [])
#@c.run('pihalf', [1.570796])
#
## add a word ":" that defines an external word
## try it by defining ": sq dup *"
#@c.run('5 sq',[25])
#
#@c.run('2 round',[]) # affects only display, not content of stack
#
## Add internal word "." that displays the last element of the stack
## Add internal word ".." that displays the complete stack
#
#@c.run('123456789 digits', [9])
#@c.run('false !', [true])
#@c.run('false not', [true])
#@c.run('true !', [false])
#@c.run('true not', [false])
#
#ass Prime.prime?(11), true
#ass Prime.prime?(12), false
#@c.run('11 prime', [true])
#@c.run('12 prime', [false])
#
#@c.run('25 sqrt',[5])
#@c.run('1 5 sqrt + 2 /',[1.618034]) # golden ratio
#@c.run('2 1 5 sqrt + /',[0.618034]) # golden ratio inverted
#
#@c.run('360 deg',[6.283185])
#@c.run('180 deg',[3.141593])
#@c.run('90 deg',[1.570796])
#
#@c.run('0 deg sin',[0])
#@c.run('30 deg sin',[0.5])
#@c.run('90 deg sin',[1])
#@c.run('pi 2 / sin',[1])
#
#@c.run('0 deg cos',[1])
#@c.run('60 deg cos',[0.5])
#@c.run('90 deg cos',[0])
#
#@c.run('0 deg tan',[0])
#@c.run('45 deg tan',[1])
#
#@c.run('0 exp',[1])
#@c.run('1 exp',[2.718282])
#@c.run('2 exp',[7.389056])
#
#@c.run('10 ln',[2.302585])
#@c.run('1 log',[0])
#@c.run('10 log',[1])
#@c.run('100 log',[2])
#@c.run('1024 log2',[10])
#
## Comparisons
#ass 1 <=> 2, -1
#@c.run('1 2 <=>',[-1])
#@c.run('2 2 <=>',[0])
#@c.run('3 2 <=>',[1])
#
#@c.run('1 2 <',[true])
#@c.run('2 2 <',[false])
#@c.run('3 2 <',[false])
#@c.run('1 2 <=',[true])
#@c.run('2 2 <=',[true])
#@c.run('3 2 <=',[false])
#
#@c.run('1 2 >',[false])
#@c.run('2 2 >',[false])
#@c.run('3 2 >',[true])
#@c.run('1 2 >=',[false])
#@c.run('2 2 >=',[true])
#@c.run('3 2 >=',[true])
#
#@c.run('1 2 ==',[false])
#@c.run('2 2 ==',[true])
#@c.run('1 2 !=',[true])
#@c.run('2 2 !=',[false])
#
## Bit manipulations
#@c.run('1 2 &',[0])
#@c.run('1 3 &',[1])
#
#@c.run('1 2 |',[3])
#@c.run('1 3 |',[3])
#
#@c.run('1 2 ^',[3])
#@c.run('1 3 ^',[2])
#@c.run('15 5 ^',[10])
#
#@c.run('-2 ~',[1])
#@c.run('-1 ~',[0])
#@c.run('0 ~',[-1])
#@c.run('1 ~',[-2])
#@c.run('2 ~',[-3])
#
## Logical operations
#@c.run('false',[false])
#@c.run('true',[true])
#
#@c.run('false false &&',[false])
#@c.run('false true &&',[false])
#@c.run('true false &&',[false])
#@c.run('true true &&',[true])
#
#@c.run('false false ||',[false])
#@c.run('false true ||',[true])
#@c.run('true false ||',[true])
#@c.run('true true ||',[true])
#
#@c.run('false false and',[false])
#@c.run('false true and',[false])
#@c.run('true false and',[false])
#@c.run('true true and',[true])
#
#@c.run('false false or',[false])
#@c.run('false true or',[true])
#@c.run('true false or',[true])
#@c.run('true true or',[true])
#
#@c.run('false false xor',[false])
#@c.run('false true xor',[true])
#@c.run('true false xor',[true])
#@c.run('true true xor',[false])
#
#@c.run('false not',[true])
#@c.run('true not',[false])
#
#ass 12.gcd(15), 3
#@c.run('12 15 gcd',[3])
#ass 12.lcm(15), 60
#@c.run('12 15 lcm',[60])
#
## add an internal word "vars" that print all the variables names and values
#
## add some external words using ":"
#@c.run('1 usd',[7.25])
#@c.run('2 eur',[19])
#@c.run('1 usd 2 eur +',[26.25])
#@c.run('1 usd_eur',[0.76],2)
#@c.run('2 eur_usd',[2.62],2)
#@c.run('3 4 hypotenusa', [5.0])
#
#@c.run('12 13 serie', [25])
#@c.run('2 5 para', [1.43],2)
#@c.run('2 5 para 12 serie', [13.43],2)
## https://www.wisc-online.com/learn/career-clusters/stem/dce3202/series-parallel-resistance--practice-problems
#
## add an internal word "defs" that print all the words names and bodys
#
## add some internal words regarding input and output
#@c.run('255 hex', ['ff'])
#@c.run('hex ff dec', [255])
#@c.run('15 bin', ['1111'])
#@c.run('111 bin 111 oct 111 hex 111 + + + dec', [464])
#@c.run('3405691582 hex', ['cafebabe'])
#
## Add internal word "now" that displays date and time. Use Time.now. Subtraction allowed
#
#@c.run('1 2 4 nim1', [6,5,3])
#@c.run('1 2 4 nim2', [0,0,1])
#
## Add internal word "if" that skips the rest of the line if the stack top is false
## Check it out by defining ": sum dup 1 > if dup 1 - sum +"
#
## Add some external words.
#@c.run('100 sum', [5050])
#@c.run('2 sum', [3])
#@c.run('1 sum', [1])
#@c.run('0 sum', [0])
#
#@c.run('5 fact', [120])
#
#@c.run('1 fib', [1])
#@c.run('2 fib', [2])
#@c.run('3 fib', [3])
#@c.run('4 fib', [5])
#@c.run('10 fib', [89])
#@c.run('1 1 10 fibq',[89, 144, 0])
#@c.run('1 1 20 fibq',[10946, 17711, 0])
#@c.run('1 1 36 fibq',[24157817, 39088169, 0])
#@c.run('1 1 1000 fibq drp swp drp digits',[210])
#
#@c.run('100 1 iter',[100, 10])
#@c.run('1000 1 iter',[1000, 31.622777])
#@c.run('25 20 zero drp',[31.622777])
#@c.run('1 1 gr',[24157817, 39088169])
