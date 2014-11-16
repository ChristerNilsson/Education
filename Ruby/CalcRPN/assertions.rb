require 'colorize'

def assert a,b
  return if a == b
  topreq = ":in `<top (required)>'"
  puts
  puts "Assert Failure: #{caller.select {|x| x.include?(topreq) }.first.gsub(topreq,'')}"
  puts "Actual: #{(' '+a.to_s+' ').red}"
  puts "Expect: #{(' '+b.to_s+' ').green}"
end

def assrt a,b,decs=6
  case a.class.name
  when 'Array'
    return assert a,b if a.size != b.size
    a = a.map { |x| x.class.name=='Float' ? x.round(decs) : x }
    b = b.map { |x| x.class.name=='Float' ? x.round(decs) : x }
    assert a,b if a != b
  when 'Float'
    assert a,b if a.round(decs) != b.round(decs)
  else
    assert a,b if a != b
  end
end

@rpn = CalcRPN.new
define_externals @rpn

def ass input, output=[],decs=6
  assrt @rpn.run(input),output,decs
end

assert 2+3,5   # Always succeeds.
#assert 2+3,6  # Always fails. Check out the message and the link to the failing assert!

ass '2', [2]
ass '1 2', [1,2]

# Stack manipulation
#ass '1 2 3 dup', [1,2,3,3]
#ass '1 2 3 dup2',[1,2,3,2,3]
#ass '1 2 3 swp', [1,3,2]
#ass '1 2 3 rdn', [3,1,2]
#ass '1 2 3 rup', [2,3,1]
#ass '1 2 3 rev', [3,2,1]
#ass '1 2 3 drp', [1,2]
#
#ass '-3 chs', [3]
#ass '3 chs', [-3]
#ass '1 2 3 clr', []
#
## No operands
#ass 'pi', [Math::PI]
#
## One operand
#ass '-3 abs', [3]
#ass '3 abs', [3]
#ass '2 inv', [0.5]
#ass '0.25 inv', [4]
#ass 'pi int',[3]
#ass '3 float',[3.0]
#
## Two operands
#ass '2 3 +',[5]
#ass '2 3 -',[-1]
#ass '2 3 4 + *',[14]
#ass '5 2 /',[2]
#ass '5 2 float /',[2.5]
#ass '2 3 **',[8]
#ass '3 2 **',[9]
#ass '3 2 mod',[1]
#ass '2 3 mod',[2]
#
## all words starting with @ should act as "save as"
#ass 'pi 2 / @pihalf', []
#ass 'pihalf',[1.570796]
#
## add a word ":" that defines an external word
## try it by defining ": sq dup *"
#ass '5 sq',[25]
#
#ass '2 round',[] # affects only display, not content of stack
#
## Add internal word "." that displays the last element of the stack
## Add internal word ".." that displays the complete stack
#
#ass '123456789 digits', [9]
#ass 'false !', [true]
#ass 'false not', [true]
#ass 'true !', [false]
#ass 'true not', [false]
#
#assert Prime.prime?(11), true
#assert Prime.prime?(12), false
#ass '11 prime', [true]
#ass '12 prime', [false]
#
#ass '25 sqrt',[5]
#ass '1 5 sqrt + 2 /',[1.618034] # golden ratio
#ass '2 1 5 sqrt + /',[0.618034] # golden ratio inverted
#
#ass '360 deg',[6.283185]
#ass '180 deg',[3.141593]
#ass '90 deg',[1.570796]
#
#ass '0 deg sin',[0]
#ass '30 deg sin',[0.5]
#ass '90 deg sin',[1]
#ass 'pi 2 / sin',[1]
#
#ass '0 deg cos',[1]
#ass '60 deg cos',[0.5]
#ass '90 deg cos',[0]
#
#ass '0 deg tan',[0]
#ass '45 deg tan',[1]
#
#ass '0 exp',[1]
#ass '1 exp',[2.718282]
#ass '2 exp',[7.389056]
#
#ass '10 ln',[2.302585]
#ass '1 log',[0]
#ass '10 log',[1]
#ass '100 log',[2]
#ass '1024 log2',[10]
#
## Comparisons
#assert 1 <=> 2, -1
#ass '1 2 <=>',[-1]
#ass '2 2 <=>',[0]
#ass '3 2 <=>',[1]
#
#ass '1 2 <',[true]
#ass '2 2 <',[false]
#ass '3 2 <',[false]
#ass '1 2 <=',[true]
#ass '2 2 <=',[true]
#ass '3 2 <=',[false]
#
#ass '1 2 >',[false]
#ass '2 2 >',[false]
#ass '3 2 >',[true]
#ass '1 2 >=',[false]
#ass '2 2 >=',[true]
#ass '3 2 >=',[true]
#
#ass '1 2 ==',[false]
#ass '2 2 ==',[true]
#ass '1 2 !=',[true]
#ass '2 2 !=',[false]
#
## Bit manipulations
#ass '1 2 &',[0]
#ass '1 3 &',[1]
#
#ass '1 2 |',[3]
#ass '1 3 |',[3]
#
#ass '1 2 ^',[3]
#ass '1 3 ^',[2]
#ass '15 5 ^',[10]
#
#ass '-2 ~',[1]
#ass '-1 ~',[0]
#ass '0 ~',[-1]
#ass '1 ~',[-2]
#ass '2 ~',[-3]
#
## Logical operations
#ass 'false',[false]
#ass 'true',[true]
#
#ass 'false false &&',[false]
#ass 'false true &&',[false]
#ass 'true false &&',[false]
#ass 'true true &&',[true]
#
#ass 'false false ||',[false]
#ass 'false true ||',[true]
#ass 'true false ||',[true]
#ass 'true true ||',[true]
#
#ass 'false false and',[false]
#ass 'false true and',[false]
#ass 'true false and',[false]
#ass 'true true and',[true]
#
#ass 'false false or',[false]
#ass 'false true or',[true]
#ass 'true false or',[true]
#ass 'true true or',[true]
#
#ass 'false false xor',[false]
#ass 'false true xor',[true]
#ass 'true false xor',[true]
#ass 'true true xor',[false]
#
#ass 'false not',[true]
#ass 'true not',[false]
#
#assert 12.gcd(15), 3
#ass '12 15 gcd',[3]
#assert 12.lcm(15), 60
#ass '12 15 lcm',[60]
#
## add an internal word "vars" that print all the variables names and values
#
## add some external words using ":"
#ass '1 usd',[7.25]
#ass '2 eur',[19]
#ass '1 usd 2 eur +',[26.25]
#ass '1 usd_eur',[0.76],2
#ass '2 eur_usd',[2.62],2
#ass '3 4 hypotenusa', [5.0]
#
## Beräkning av seriekopplade och parallellkopplade motstånd.
## Serie:   R = R1 + R2
## Para:  1/R = 1/R1 + 1/R2
## https://www.wisc-online.com/learn/career-clusters/stem/dce3202/series-parallel-resistance--practice-problems
#ass '12 13 serie', [25]
#ass '2 5 para', [1.43],2
#ass '2 5 para 12 serie', [13.43],2
#
## add an internal word "defs" that print all the words names and bodys
#
## add some internal words regarding input and output
#ass '255 hex', ['ff']
#ass 'hex ff dec', [255]
#ass '15 bin', ['1111']
#ass '111 bin 111 oct 111 hex 111 + + + dec', [464]
#ass '3405691582 hex', ['cafebabe']
#
## Add internal word "now" that displays date and time. Use Time.now. Subtraction allowed
#
## Teach the computer to play a perfect game of nim.
## http://sv.wikipedia.org/wiki/Nim
## http://en.wikipedia.org/wiki/Nim#Mathematical_theory
#ass '1 2 4 nim1', [6,5,3]
#ass '1 2 4 nim2', [0,0,1]
#
## Add internal word "if" that skips the rest of the line if the stack top is false
#
## Check it out by defining ": sum dup 1 > if dup 1 - sum +"
#ass '0 sum', [0]
#ass '1 sum', [0+1]
#ass '2 sum', [0+1+2]
#ass '100 sum', [5050]
#
## Calculate factorial
## http://sv.wikipedia.org/wiki/Fakultet_(matematik)
#ass '3 fact', [1*2*3]
#ass '5 fact', [1*2*3*4*5]
#
## Calculate fibonacci numbers: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
## http://sv.wikipedia.org/wiki/Fibonaccital
#ass '1 fib', [0+1]
#ass '2 fib', [1+1]
#ass '3 fib', [1+2]
#ass '4 fib', [2+3]
#ass '10 fib', [34+55]
#
## fib enligt ovan exekverar extremt långsamt.
## Definiera en mycket snabbare funktion, fibq.
## http://en.wikipedia.org/wiki/Dynamic_programming#Fibonacci_sequence
#ass '1 1 10 fibq',[89, 144, 0]
#ass '1 1 20 fibq',[10946, 17711, 0]
#ass '1 1 36 fibq',[24157817, 39088169, 0]
#ass '1 1 1000 fibq drp swp drp digits',[210]
#
## ÖVERKURS - Följande uppgifter löses på egen risk.
#
## beräkna medelvärde.
#ass '10 20 avg', [15]
#ass '10 11 avg', [10.5]
#
## beräkna kvadratroten med Newtons metod http://sv.wikipedia.org/wiki/Newtons_metod#Exempel
## 10 iterationer ger 15 decimaler på en millisekund.
#ass '1000 my_sqrt',[31.622776601683793],15
#
## Beräkna e med Eulers metod (1.2) http://numbers.computation.free.fr/Constants/E/e.html
## e = 1/0! + 1/1! + 1/2! + 1/3! + 1/4! + ...
## 20 iterationer ger 15 decimaler på en millisekund.
#ass 'my_e', [2.718281828459046, 0.0, 21], 15
#
## Beräkna pi med Viete http://www.codeproject.com/Articles/813185/Calculating-the-Number-PI-Through-Infinite-Sequenc
## 26 iterationer ger 15 decimaler på en millisekund.
#ass 'my_pi', [2.0, 3.141592653589793], 15
