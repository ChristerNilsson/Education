# https://github.com/ChristerNilsson/Education/blob/master/CalcRPN/Ruby/start.rb

class CalcRPN
  def initialize
    reset

    @words0 = {}
    @words0['?'] = -> { puts; show @words0,0; show @words1,1; show @words2,2; puts}
    @words0['q'] = -> {exit}
    @words0['clr'] = -> {@stack = []}

    @words1 = {}
    @words1['drp'] = -> { @stack = @stack }

    @words2 = {}
    @words2['+'] = -> {@stack << @x + @y}
  end

  def reset
    @stack = []
  end

  def prompt
    "#{@stack.last(4).to_s.gsub('"','')} Command: "
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
      procs = [@words0[x],@words1[x],@words2[x]]
      n = procs.index {|proc| proc!=nil}
      if n
        if n > @stack.size
          puts "stack too small for #{x}"
          return
        end
        @x = @stack.pop if n>=1
        @y = @stack.pop if n==2
        return if procs[n].call == nil
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

  def run s
    reset
    calc s.split
    @stack
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

@c = CalcRPN.new
require '.\assertions'
@c.loop