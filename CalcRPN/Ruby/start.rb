# Calc RPN (Ruby) Start
# Christer Nilsson 2014

def assert a,b
  if a!=b
    puts "Assert failed: #{a} != #{b} #{caller[0]}"
  end
end

@s = []

def calc lst
  lst.each do |x|
    case x
    when '?'
      puts '? + drp clr q'
    when '+'
      @s << @s.pop + @s.pop
    when 'drp'
      @s.pop
    when 'clr'
      @s = []
    when 'q'
      exit
    else
      @s << x.to_f
    end
  end
  @s.last
end

assert 2+3, 5
#assert 2+3, 6

def run s
  @s = []
  calc s.split
  @s
end

assert run('1 2'),[1,2]
#assert run('1 2 3 dup'), [1,2,3,3]
#assert run('1 2 3 dup2'),[1,2,3,2,3]
#assert run('1 2 3 dup3'),[1,2,3,1,2,3]
#assert run('1 2 3 swp'), [1,3,2]
#assert run('1 2 3 rdn'), [3,1,2]
#assert run('1 2 3 rup'), [2,3,1]
#assert run('1 2 3 rev'), [3,2,1]
#assert run('1 2 3 drp'), [1,2]
#assert run('1 2 3 clr'), []
#
#assert run('2'),[2]
#assert run('2 3 +'),[5]
#assert run('2 3 -'),[-1]
#assert run('2 3 4 + *'),[14]
#assert run('5 2 /'),[2]
#assert run('15 5 xor'),[10]
#assert run('25 sqrt'),[5]
#
#assert run('1 5 sqrt + 2 /'),[1.618033988749895]
#assert run('2 1 5 sqrt + /'),[0.6180339887498948]
#
#assert run('5 sq'),[25]
#
#assert run('1 usd'),[7.25]
#assert run('2 eur'),[19]
#assert run('1 usd 2 eur +'),[26.25]
#assert run('1 usd_eur'),[0.7631578947368421]
#assert run('2 eur_usd'),[2.6206896551724137]
#
#assert run('3 4 hypotenusa'), [5.0]
#
#assert run('pi 2 / @pihalva'), []
#assert run('pihalva'), [1.57079632675]
#
#assert run('1 2 4 nim1'), [6,5,3] # Börja med denna lösning
#assert run('1 2 4 nim2'), [0,0,1] # Förbättra därefter till denna.
#
#assert run('5 fact'), [120]
#
#assert run('100 sum'), [5050]
#assert run('2 sum'), [3]
#assert run('1 sum'), [1]
#assert run('0 sum'), [0]
#
#assert run('1 fib'), [1]
#assert run('2 fib'), [2]
#assert run('3 fib'), [3]
#assert run('4 fib'), [5]
#assert run('10 fib'), [89]
#
#assert Prime.prime?(11), true
#assert Prime.prime?(12), false
#assert run('11 prime'), [true]
#assert run('12 prime'), [false]
#assert 12.gcd(15), 3
#assert run('12 15 gcd'),[3]
#assert 12.lcm(15), 60
#assert run('12 15 lcm'),[60]
#
#assert run('255 hex'), ['ff']
#assert run('hex ff dec'), [255]
#assert run('15 bin'), ['1111']
#assert run('111 bin 111 oct 111 hex 111 + + + dec'), [464]
#assert run('3405691582 hex'), ['cafebabe']
#
#assert run('12 13 serie'), [25]
#assert run('2.0 5.0 para'), [1.4285714285714286]
#assert run('2.0 5.0 para 12 serie'), [13.428571428571429]
#
#assert run('100 1 iter'),[100, 10]
#assert run('1000 1 iter'),[1000, 31.622776601684336]
#
#assert run('25 20 zero'),[31.62277660168379, -8.881784197001252e-15]

@s = []
calc ['?']
while true
  print @s.to_s + ' Command: '
  calc gets.chomp.split
end