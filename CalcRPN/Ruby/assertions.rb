def show_failure a,b
  puts
  puts 'Assert failed!'
  puts "Actual: #{a}"
  puts "Expect: #{b}"
  print 'Line: '
  caller.each { |x| puts x if x.include?('assertions') && x.include?('top') }
end

def assert a,b,decs=6
  case a.class.name
  when 'Array'
    return show_failure a,b if a.size != b.size
    a = a.map { |x| x.class.name=='Float' ? x.round(decs) : x }
    b = b.map { |x| x.class.name=='Float' ? x.round(decs) : x }
    show_failure a,b if a != b
  when 'Float'
    show_failure a,b if a.round(decs) != b.round(decs)
  else
    show_failure a,b if a != b
  end
end

@rpn = CalcRPN.new
define_externals @rpn

def run input, output=[],decs=6
  assert @rpn.run(input),output,decs
end

assert 2+3,5   # Always succeeds.
#assert 2+3,6  # Always fails. Check out the message and the link to the failing assert!

run '2', [2]
run '1 2', [1,2]

## Stack manipulation
#run '1 2 3 dup', [1,2,3,3]
#run '1 2 3 dup2',[1,2,3,2,3]
#run '1 2 3 swp', [1,3,2]
#run '1 2 3 rdn', [3,1,2]
#run '1 2 3 rup', [2,3,1]
#run '1 2 3 rev', [3,2,1]
#run '1 2 3 drp', [1,2]
#
#run '-3 chs', [3]
#run '3 chs', [-3]
#run '1 2 3 clr', []
#
## No operands
#run 'pi', [Math::PI]
#
## One operand
#run '-3 abs', [3]
#run '3 abs', [3]
#run '2 inv', [0.5]
#run '0.25 inv', [4]
#run 'pi int',[3]
#run '3 float',[3.0]
#
## Two operands
#run '2 3 +',[5]
#run '2 3 -',[-1]
#run '2 3 4 + *',[14]
#run '5 2 /',[2]
#run '5 2 float /',[2.5]
#run '2 3 **',[8]
#run '3 2 **',[9]
#run '3 2 mod',[1]
#run '2 3 mod',[2]
#
## all words starting with @ should act as "save as"
#run 'pi 2 / @pihalf pihalf pihalf +', [3.141593]
#
## add a word ":" that defines an external word
## try it by defining ": sq dup *"
#run '5 sq',[25]
#
#run '2 round',[] # affects only display, not content of stack
#
## Add internal word "." that displays the last element of the stack
## Add internal word ".." that displays the complete stack
#
#run '123456789 digits', [9]
#run 'false !', [true]
#run 'false not', [true]
#run 'true !', [false]
#run 'true not', [false]
#
#assert Prime.prime?(11), true
#assert Prime.prime?(12), false
#run '11 prime', [true]
#run '12 prime', [false]
#
#run '25 sqrt',[5]
#run '1 5 sqrt + 2 /',[1.618034] # golden ratio
#run '2 1 5 sqrt + /',[0.618034] # golden ratio inverted
#
#run '360 deg',[6.283185]
#run '180 deg',[3.141593]
#run '90 deg',[1.570796]
#
#run '0 deg sin',[0]
#run '30 deg sin',[0.5]
#run '90 deg sin',[1]
#run 'pi 2 / sin',[1]
#
#run '0 deg cos',[1]
#run '60 deg cos',[0.5]
#run '90 deg cos',[0]
#
#run '0 deg tan',[0]
#run '45 deg tan',[1]
#
#run '0 exp',[1]
#run '1 exp',[2.718282]
#run '2 exp',[7.389056]
#
#run '10 ln',[2.302585]
#run '1 log',[0]
#run '10 log',[1]
#run '100 log',[2]
#run '1024 log2',[10]
#
## Comparisons
#assert 1 <=> 2, -1
#run '1 2 <=>',[-1]
#run '2 2 <=>',[0]
#run '3 2 <=>',[1]
#
#run '1 2 <',[true]
#run '2 2 <',[false]
#run '3 2 <',[false]
#run '1 2 <=',[true]
#run '2 2 <=',[true]
#run '3 2 <=',[false]
#
#run '1 2 >',[false]
#run '2 2 >',[false]
#run '3 2 >',[true]
#run '1 2 >=',[false]
#run '2 2 >=',[true]
#run '3 2 >=',[true]
#
#run '1 2 ==',[false]
#run '2 2 ==',[true]
#run '1 2 !=',[true]
#run '2 2 !=',[false]
#
## Bit manipulations
#run '1 2 &',[0]
#run '1 3 &',[1]
#
#run '1 2 |',[3]
#run '1 3 |',[3]
#
#run '1 2 ^',[3]
#run '1 3 ^',[2]
#run '15 5 ^',[10]
#
#run '-2 ~',[1]
#run '-1 ~',[0]
#run '0 ~',[-1]
#run '1 ~',[-2]
#run '2 ~',[-3]
#
## Logical operations
#run 'false',[false]
#run 'true',[true]
#
#run 'false false &&',[false]
#run 'false true &&',[false]
#run 'true false &&',[false]
#run 'true true &&',[true]
#
#run 'false false ||',[false]
#run 'false true ||',[true]
#run 'true false ||',[true]
#run 'true true ||',[true]
#
#run 'false false and',[false]
#run 'false true and',[false]
#run 'true false and',[false]
#run 'true true and',[true]
#
#run 'false false or',[false]
#run 'false true or',[true]
#run 'true false or',[true]
#run 'true true or',[true]
#
#run 'false false xor',[false]
#run 'false true xor',[true]
#run 'true false xor',[true]
#run 'true true xor',[false]
#
#run 'false not',[true]
#run 'true not',[false]
#
#assert 12.gcd(15), 3
#run '12 15 gcd',[3]
#assert 12.lcm(15), 60
#run '12 15 lcm',[60]
#
## add an internal word "vars" that print all the variables names and values
#
## add some external words using ":"
#run '1 usd',[7.25]
#run '2 eur',[19]
#run '1 usd 2 eur +',[26.25]
#run '1 usd_eur',[0.76],2
#run '2 eur_usd',[2.62],2
#run '3 4 hypotenusa', [5.0]
#
#run '12 13 serie', [25]
#run '2 5 para', [1.43],2
#run '2 5 para 12 serie', [13.43],2
## https://www.wisc-online.com/learn/career-clusters/stem/dce3202/series-parallel-resistance--practice-problems
#
## add an internal word "defs" that print all the words names and bodys
#
## add some internal words regarding input and output
#run '255 hex', ['ff']
#run 'hex ff dec', [255]
#run '15 bin', ['1111']
#run '111 bin 111 oct 111 hex 111 + + + dec', [464]
#run '3405691582 hex', ['cafebabe']
#
## Add internal word "now" that displays date and time. Use Time.now. Subtraction allowed
#
#run '1 2 4 nim1', [6,5,3]
#run '1 2 4 nim2', [0,0,1]
#
## Add internal word "if" that skips the rest of the line if the stack top is false
## Check it out by defining ": sum dup 1 > if dup 1 - sum +"
#
## Add some external words.
#run '100 sum', [5050]
#run '2 sum', [3]
#run '1 sum', [1]
#run '0 sum', [0]
#
#run '5 fact', [120]
#
#run '1 fib', [1]
#run '2 fib', [2]
#run '3 fib', [3]
#run '4 fib', [5]
#run '10 fib', [89]
#run '1 1 10 fibq',[89, 144, 0]
#run '1 1 20 fibq',[10946, 17711, 0]
#run '1 1 36 fibq',[24157817, 39088169, 0]
#run '1 1 1000 fibq drp swp drp digits',[210]
#
#run '100 1 iter',[100, 10]
#run '1000 1 iter',[1000, 31.622777]
#run '25 20 zero drp',[31.622777]
#run '1 1 gr',[24157817, 39088169]
