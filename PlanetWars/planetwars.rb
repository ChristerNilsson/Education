# Make your own bot and win the game!
# Inspiration: http://planetwars.aichallenge.org/visualizer.php?game_id=9559558
# Specification: http://planetwars.aichallenge.org/specification.php
# Source Code: https://code.google.com/p/ai-contest/source/browse/#svn/trunk/planet_wars

class Player
  attr_accessor :pw

  def initialize(player)
    @orders = []
    @player = player
  end

  def issue_order(source, dest, ships)
    @orders << Order.new(source, dest, ships.round)
  end

  def orders
    res = @orders
    @orders = []
    res
  end

  def planets
    @pw.planets
  end

  def fleets
    @pw.fleets
  end

  def my_planets
    @pw.my_planets @player
  end

  def my_fleets
    @pw.my_fleets @player
  end

  def enemy_fleets
    @pw.my_fleets @player
  end

  def enemy_planets
    @pw.enemy_planets @player
  end

  def not_my_planets
    @pw.not_my_planets @player
  end

  def neutral_planets
    @pw.neutral_planets @player
  end

  def distance source, dest
    @pw.distance(source, dest)
  end
end

class Fleet
  attr_reader :owner, :num_ships, :source, :dest, :total_trip_length, :turns_remaining

  def initialize(pw, owner, num_ships, source, dest, total_trip_length, turns_remaining)
    @owner, @num_ships = owner, num_ships
    @source=source
    @dest = dest
    @src = pw.planets[source]
    @dst = pw.planets[dest]
    @total_trip_length = total_trip_length
    @turns_remaining = turns_remaining
  end

  def x
    ((@total_trip_length - @turns_remaining) * @dst.x + @turns_remaining * @src.x) / @total_trip_length
  end

  def y
    ((@total_trip_length - @turns_remaining) * @dst.y + @turns_remaining * @src.y) / @total_trip_length
  end

  def direction
    Math.atan2(@dst.y-@src.y, @dst.x-@src.x)
  end

  def decr
    @turns_remaining -= 1
  end

  def to_s
    "F #{owner} #{num_ships} #{source} #{dest} #{total_trip_length} #{turns_remaining}"
  end
end

class Planet
  attr_reader :id, :growth_rate, :x, :y
  attr_accessor :owner, :num_ships

  def initialize(id, owner, num_ships, growth_rate, x, y)
    @id, @owner, @num_ships = id, owner, num_ships
    @growth_rate, @x, @y = growth_rate, x, y
  end

  def add_ships(n)
    @num_ships += amt
  end

  def remove_ships(n)
    @num_ships -= n
  end

  def to_s
    "P #{x} #{y} #{owner} #{num_ships} #{growth_rate}"
  end

  def distance(destination)
    Math::hypot(self.x - destination.x, self.y - destination.y)
  end
end

class Order
  attr_accessor :source, :dest, :num_ships

  def initialize source, dest, num_ships
    @source = source
    @dest = dest
    @num_ships = num_ships
  end
end

class PlanetWars
  attr_reader :planets, :fleets, :filename, :steps, :player1, :player2

  def initialize(filename = 'txt/state.txt', player1, player2)
    @filename = filename
    @steps = []
    @player1 = player1
    @player2 = player2
    @player1.pw = self
    @player2.pw = self
    game_state = File.open(filename, 'r').read
    #@player = ARGV.size>0 ? ARGV[0].to_i : 0
    #File.open("txt/cmd#{@player}.txt", 'w') {}
    read_state(game_state)

    @steps << {:fleets => [], :planets => @planets}
    #@f = File.open("txt/cmd#{@player}.txt",'w')
  end

  def num_planets
    @planets.length
  end

  def get_planet(id)
    @planets[id]
  end

  def num_fleets
    @fleets.length
  end

  def get_fleet(id)
    @fleets[id]
  end

  def my_planets player
    @planets.select { |planet| planet.owner == player }
  end

  def neutral_planets
    @planets.select { |planet| planet.owner == 0 }
  end

  def enemy_planets player
    @planets.select { |planet| planet.owner == 3 - player }
  end

  def not_my_planets player
    @planets.reject { |planet| planet.owner == player }
  end

  def my_fleets player
    @fleets.select { |fleet| fleet.owner == player }
  end

  def enemy_fleets player
    @fleets.select { |fleet| fleet.owner == 3 - player }
  end

  def ships(player)
    res = 0
    @planets.select { |planet| planet.owner == player }.each { |p| res += p.num_ships }
    @fleets.select { |fleet| fleet.owner == player }.each { |f| res += f.num_ships }
    res
  end

  def score player
    growth = 0
    @planets.select { |planet| planet.owner == player }.each do |p|
      growth += p.growth_rate
    end
    "#{ships(player)}/#{growth}"
  end

  def to_s
    s = []
    @planets.each do |p|
      s << p.to_s
    end
    @fleets.each do |f|
      s << f.to_s
    end
    return s.join("\n")
  end

  def distance(source, destination)
    Math::hypot(source.x - destination.x, source.y - destination.y)
  end

  def travel_time(source, destination)
    distance(source, destination).ceil
  end

  def issue_order(source, destination, num_ships)
    @f.puts "#{source} #{destination} #{num_ships}"
  end

  def is_alive(player)
    ((@planets.select { |p| p.owner == player }).length > 0) || ((@fleets.select { |p| p.owner == player }).length > 0)
  end

  def planet_count(player)
    (@planets.select { |p| p.owner == player }).size
  end

  def fleet_count(player) # in active fleets
    (@fleets.select { |p| p.owner == player }).size
  end

  def execute(step)
    if step >= @steps.length
      while @steps.length <= step
        do_step
        @steps << {:fleets => @fleets, :planets => @planets}
      end
      @steps[step]
    else
      @steps[step]
    end
  end

  def do_step
    @player1.do_turn
    @player2.do_turn

    orders1 = @player1.orders
    orders2 = @player2.orders

    execute_player 1, orders1
    execute_player 2, orders2

    update_fleets
    update_planets
  end

  def execute_player(no, orders)
    orders.each do |order|
      p1 = order.source
      p2 = order.dest
      num_ships = order.num_ships
      source = @planets[p1]
      dest = @planets[p2]
      d = distance(source, dest)
      t = travel_time(source, dest)
      @fleets << Fleet.new(self, no, num_ships, p1, p2, d, t)
      source.num_ships -= num_ships
    end
  end

  def update_fleets
    @fleets.delete_if { |fleet| fleet.turns_remaining == -1 }
    @fleets.each do |fleet|
      if fleet.turns_remaining == 0
        planet = @planets[fleet.dest]
        puts "Fleet owned by #{fleet.owner} arrives with #{fleet.num_ships} ships to planet #{planet.id}" if TRACE
        if planet.owner == fleet.owner
          planet.num_ships += fleet.num_ships
        else
          planet.num_ships -= fleet.num_ships
          if planet.num_ships < 0
            planet.num_ships *= -1
            planet.owner = fleet.owner
          end
        end
      end
      fleet.decr
    end
  end

  def update_planets
    @planets.each do |planet|
      next if planet.owner == 0
      planet.num_ships += planet.growth_rate
    end
  end

  def read_state(s)
    @planets = []
    @fleets = []
    lines = s.split("\n")
    id = 0

    lines.each do |line|
      line = line.split('#')[0]
      tokens = line.split(' ')
      next if tokens.length == 1
      if tokens[0] == 'P'
        return 0 if tokens.length != 6
        p = Planet.new(id,
                       tokens[3].to_i, # owner
                       tokens[4].to_i, # num_ships
                       tokens[5].to_i, # growth_rate
                       tokens[1].to_f, # x
                       tokens[2].to_f) # y
        id += 1
        @planets << p
      elsif tokens[0] == 'F'
        return 0 if tokens.length != 7
        f = Fleet.new(self, tokens[1].to_i, # owner
                      tokens[2].to_i, # num_ships
                      tokens[3].to_i, # source
                      tokens[4].to_i, # destination
                      tokens[5].to_i, # total_trip_length
                      tokens[6].to_i) # turns_remaining
        @fleets << f
      else
        return 0
      end
    end
    return 1
  end

end