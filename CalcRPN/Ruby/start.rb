require 'prime'

class CalcRPN
  def initialize
    @defs = {}
    reset

    @words0 = {}
    @words1 = {}
    @words2 = {}

    @words0['?'] = -> { puts; show @words0,0; show @words1,1; show @words2,2; puts }
    @words0['quit'] = -> { exit }
    @words0['clr'] = -> { @stack = [] }

    @words1['drp'] = -> x {}

    @words2['+'] = -> x,y { @stack << y + x }

  end
  def reset
    @stack = []
  end
  def prompt
    # stack = @stack.to_s.gsub('"','')
    "#{@stack} Command: "
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

      words = [@words0[x],@words1[x],@words2[x]]
      words.each_with_index do |word,count|
        if word
          if @stack.size < count
            puts "stack too small for #{x}"
            return
          end
          case count
          when 0; word.call()
          when 1; word.call(@stack.pop)
          when 2; word.call(@stack.pop,@stack.pop)
          end
        end
      end
      next if words != [nil,nil,nil]

      x = read_number(x)
      @stack << x if x

    end
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
    #return true if x.class != String
    x.include?('.')
  end
  def loop
    run '?'
    reset
    while true
      print prompt
      calc gets.chomp.split
    end
  end
  def define s
    name, *@defs[name] = s.split
  end
  def run input
    return [] if input == ''
    reset
    calc input.split
    @stack
  end
end

def define_externals rpn
  rpn.define 'dbl 2 *'
end

require './assertions'

rpn = CalcRPN.new
define_externals rpn
rpn.loop