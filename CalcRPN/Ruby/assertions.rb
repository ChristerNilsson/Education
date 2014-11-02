def show_ass a,b
  puts "#{a} != #{b}"
  caller.each { |x| puts x if x.include?('assertions') && x.include?('top') }
end

def ass a,b,round=6
  case a.class.name
  when 'Array'
    return show_ass a,b if a.size != b.size
    a.size.times { |i| ass a[i], b[i], round }
  when 'Float'
    show_ass a,b if a.round(round) != b.round(round)
  else
    show_ass a,b if a != b
  end
end

#ass(2+3,6)
#ass(2+3,5)
#ass(@c.run('2'),[2])
#ass(@c.run('1 2'),[1,2])
#
#ass(@c.run('1 2 3 dup'), [1,2,3,3])
#ass(@c.run('1 2 3 dup2'),[1,2,3,2,3])
#ass(@c.run('1 2 3 swp'), [1,3,2])
#ass(@c.run('1 2 3 rdn'), [3,1,2])
#ass(@c.run('1 2 3 rup'), [2,3,1])
#ass(@c.run('1 2 3 rev'), [3,2,1])
#ass(@c.run('1 2 3 drp'), [1,2])
#ass(@c.run('1 2 3 clr'), [])
#ass(@c.run('pi'), [Math::PI])
#ass(@c.run('2 round'),[]) # affects only display, not content of stack
#
## Add word . that displays the last element of the stack
## Add word .. that displays the complete stack
#
## Unary operations
#ass(@c.run('-3 abs'), [3])
#ass(@c.run('3 abs'), [3])
#ass(@c.run('-3 chs'), [3])
#ass(@c.run('3 chs'), [-3])
#ass(@c.run('2 inv'), [0.5])
#ass(@c.run('0.25 inv'), [4])
#ass(@c.run('123456789 digits'), [9])
#ass(@c.run('false !'), [true])
#ass(@c.run('false not'), [true])
#ass(@c.run('true !'), [false])
#ass(@c.run('true not'), [false])
#
#ass(Prime.prime?(11), true)
#ass(Prime.prime?(12), false)
#ass(@c.run('11 prime'), [true])
#ass(@c.run('12 prime'), [false])
#
#ass(@c.run('25 sqrt'),[5])
#ass(@c.run('1 5 sqrt + 2 /'),[1.618034]) # golden ratio
#ass(@c.run('2 1 5 sqrt + /'),[0.618034]) # golden ratio inverted
#
#ass(@c.run('pi int'),[3])
#ass(@c.run('3 float'),[3.0])
#
#ass(@c.run('360 deg'),[6.283185])
#ass(@c.run('180 deg'),[3.141593])
#ass(@c.run('90 deg'),[1.570796])
#
#ass(@c.run('0 deg sin'),[0])
#ass(@c.run('30 deg sin'),[0.5])
#ass(@c.run('90 deg sin'),[1])
#ass(@c.run('pi 2 / sin'),[1])
#
#ass(@c.run('0 deg cos'),[1])
#ass(@c.run('60 deg cos'),[0.5])
#ass(@c.run('90 deg cos'),[0])
#
#ass(@c.run('0 deg tan'),[0])
#ass(@c.run('45 deg tan'),[1])
#
#ass(@c.run('0 exp'),[1])
#ass(@c.run('1 exp'),[2.718282])
#ass(@c.run('2 exp'),[7.389056])
#
#ass(@c.run('10 ln'),[2.302585])
#ass(@c.run('1 log'),[0])
#ass(@c.run('10 log'),[1])
#ass(@c.run('100 log'),[2])
#ass(@c.run('1024 log2'),[10])
#
## Binary operations
#ass(@c.run('2 3 +'),[5])
#ass(@c.run('2 3 -'),[-1])
#ass(@c.run('2 3 4 + *'),[14])
#ass(@c.run('5 2 /'),[2])
#ass(@c.run('5 2 float /'),[2.5])
#ass(@c.run('2 3 **'),[8])
#ass(@c.run('3 2 **'),[9])
#ass(@c.run('3 2 mod'),[1])
#ass(@c.run('2 3 mod'),[2])
#
## Comparisons
#ass(1 <=> 2, -1)
#ass(@c.run('1 2 <=>'),[-1])
#ass(@c.run('2 2 <=>'),[0])
#ass(@c.run('3 2 <=>'),[1])
#
#ass(@c.run('1 2 <'),[true])
#ass(@c.run('2 2 <'),[false])
#ass(@c.run('3 2 <'),[false])
#ass(@c.run('1 2 <='),[true])
#ass(@c.run('2 2 <='),[true])
#ass(@c.run('3 2 <='),[false])
#
#ass(@c.run('1 2 >'),[false])
#ass(@c.run('2 2 >'),[false])
#ass(@c.run('3 2 >'),[true])
#ass(@c.run('1 2 >='),[false])
#ass(@c.run('2 2 >='),[true])
#ass(@c.run('3 2 >='),[true])
#
#ass(@c.run('1 2 =='),[false])
#ass(@c.run('2 2 =='),[true])
#ass(@c.run('1 2 !='),[true])
#ass(@c.run('2 2 !='),[false])
#
## Bit manipulations
#
#ass(@c.run('1 2 &'),[0])
#ass(@c.run('1 3 &'),[1])
#
#ass(@c.run('1 2 |'),[3])
#ass(@c.run('1 3 |'),[3])
#
#ass(@c.run('1 2 ^'),[3])
#ass(@c.run('1 3 ^'),[2])
#ass(@c.run('15 5 ^'),[10])
#
#ass(@c.run('-2 ~'),[1])
#ass(@c.run('-1 ~'),[0])
#ass(@c.run('0 ~'),[-1])
#ass(@c.run('1 ~'),[-2])
#ass(@c.run('2 ~'),[-3])
#
## Logical operations
#ass(@c.run('false'),[false])
#ass(@c.run('true'),[true])
#
#ass(@c.run('false false &&'),[false])
#ass(@c.run('false true &&'),[false])
#ass(@c.run('true false &&'),[false])
#ass(@c.run('true true &&'),[true])
#
#ass(@c.run('false false ||'),[false])
#ass(@c.run('false true ||'),[true])
#ass(@c.run('true false ||'),[true])
#ass(@c.run('true true ||'),[true])
#
#ass(@c.run('false false and'),[false])
#ass(@c.run('false true and'),[false])
#ass(@c.run('true false and'),[false])
#ass(@c.run('true true and'),[true])
#
#ass(@c.run('false false or'),[false])
#ass(@c.run('false true or'),[true])
#ass(@c.run('true false or'),[true])
#ass(@c.run('true true or'),[true])
#
#ass(@c.run('false false xor'),[false])
#ass(@c.run('false true xor'),[true])
#ass(@c.run('true false xor'),[true])
#ass(@c.run('true true xor'),[false])
#
#ass(@c.run('false not'),[true])
#ass(@c.run('true not'),[false])
#
#ass(12.gcd(15), 3)
#ass(@c.run('12 15 gcd'),[3])
#ass(12.lcm(15), 60)
#ass(@c.run('12 15 lcm'),[60])
#
## all words starting with @ should act as "save as"
#ass(@c.run('pi 2 / @pihalf'), [])
#ass(@c.run('pihalf'), [1.570796])
#
## add a word vars that print all the variables names and values
#
## add a word : that defines a new word
## try it by defining ": sq dup *"
#
#ass(@c.run('5 sq'),[25])
#ass(@c.run('1 usd'),[7.25])
#ass(@c.run('2 eur'),[19])
#ass(@c.run('1 usd 2 eur +'),[26.25])
#ass(@c.run('1 usd_eur'),[0.76],2)
#ass(@c.run('2 eur_usd'),[2.62],2)
#ass(@c.run('3 4 hypotenusa'), [5.0])
#
#ass(@c.run('12 13 serie'), [25])
#ass(@c.run('2 5 para'), [1.43],2)
#ass(@c.run('2 5 para 12 serie'), [13.43],2)
## https://www.wisc-online.com/learn/career-clusters/stem/dce3202/series-parallel-resistance--practice-problems
#
## add a word defs that print all the words names and bodys
#
#ass(@c.run('255 hex'), ['ff'])
#ass(@c.run('hex ff dec'), [255])
#ass(@c.run('15 bin'), ['1111'])
#ass(@c.run('111 bin 111 oct 111 hex 111 + + + dec'), [464])
#ass(@c.run('3405691582 hex'), ['cafebabe'])
#
## Add word "now" that displays date and time. Use Time.now. Subtraction allowed
#
#ass(@c.run('1 2 4 nim1'), [6,5,3])
#ass(@c.run('1 2 4 nim2'), [0,0,1])
#
## Add word "if" that skips the rest of the line if the stack top is false
## Check it out by defining ": sum dup 1 > if dup 1 - sum +"
#
#ass(@c.run('100 sum'), [5050])
#ass(@c.run('2 sum'), [3])
#ass(@c.run('1 sum'), [1])
#ass(@c.run('0 sum'), [0])
#
#ass(@c.run('5 fact'), [120])
#
#ass(@c.run('1 fib'), [1])
#ass(@c.run('2 fib'), [2])
#ass(@c.run('3 fib'), [3])
#ass(@c.run('4 fib'), [5])
#ass(@c.run('10 fib'), [89])
#ass(@c.run('1 1 10 fibq'),[89, 144, 0])
#ass(@c.run('1 1 20 fibq'),[10946, 17711, 0])
#ass(@c.run('1 1 36 fibq'),[24157817, 39088169, 0])
#ass(@c.run('1 1 1000 fibq drp swp drp digits'),[210])
#
#ass(@c.run('100 1 iter'),[100, 10])
#ass(@c.run('1000 1 iter'),[1000, 31.622777])
#ass(@c.run('25 20 zero drp'),[31.622777])
#ass(@c.run('1 1 gr'),[24157817, 39088169])
