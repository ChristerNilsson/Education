# https://github.com/ChristerNilsson/Education/blob/master/CalcRPN/Ruby/start.rb

require 'prime'


def show_ass a,b
  puts "#{a} != #{b}"
  caller.each { |x| puts x if x.include?('assertions') && x.include?('top') }
end

def ass a,b,decs=6
  case a.class.name
  when 'Array'
    return show_ass a,b if a.size != b.size
    a = a.map { |x| x.class.name=='Float' ? x.round(decs) : x }
    b = b.map { |x| x.class.name=='Float' ? x.round(decs) : x }
    show_ass a,b if a != b
  when 'Float'
    show_ass a,b if a.round(decs) != b.round(decs)
  else
    show_ass a,b if a != b
  end
end

class CalcRPN
  def initialize
    reset

    @words0 = {}
    @words0['?'] = -> {puts; show @words0,0; show @words1,1; show @words2,2; puts}
    @words0['quit'] = -> {exit}
    @words0['clr'] = -> {@stack = []}

    @words1 = {}
    @words1['drp'] = -> x { x = x }

    @words2 = {}
    @words2['+'] = -> x,y {@stack << y + x}
  end

  def reset
    @stack = []
  end

  def prompt
    #stack = @stack.map do |x|
    #  case x.class.name
    #  when 'Float'
    #    x.round(@round)
    #  when 'Fixnum'
    #    x.to_s(@base)
    #  else
    #    x
    #  end
    #end
    stack = @stack.to_s.gsub('"','')
    "#{stack} Command: "
  end

  def show d,i
    puts "#{i}: #{d.keys.sort.join(' ')}"
  end
  def integer? obj
    true if Integer(obj) rescue false
  end
  def float? obj
    true if Float(obj) rescue false
  end

  def calc lst

    lst.each do |x|

      word = @words0[x]
      if word
        return if word.call == nil
        next
      end

      word = @words1[x]
      if word
        if @stack.size < 1
          puts "stack too small for #{x}"
          return
        end
        return if word.call(@stack.pop) == nil
        next
      end

      word = @words2[x]
      if word
        if @stack.size < 2
          puts "stack too small for #{x}"
          return
        end
        return if word.call(@stack.pop,@stack.pop) == nil
        next
      end

      x = read_number(x)
      @stack << x if x

    end
    @stack.last
  end

  def read_number x
    if integer?(x) and not dot(x)
      res = x.to_i
    elsif float?(x)
      res = x.to_f
    end
    return res if res
    puts "#{x} is unknown."
    nil
  end

  def dot x
    return true if x.class != String
    x.include?('.')
  end

  def run input, output=[],round=6
    reset
    calc input.split
    ass @stack,output,round
  end

  def loop
    run '?'
    reset
    while true
      print prompt
      calc gets.chomp.split
    end
  end

end

def define_externals
  #@c.run(': sq dup *') # n -- n
end

@c = CalcRPN.new
define_externals
require './assertions'
@c.loop