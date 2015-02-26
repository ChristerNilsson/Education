# Make your own bot and win the game!
# Inspiration: http://planetwars.aichallenge.org/visualizer.php?game_id=9559558
# Specification: http://planetwars.aichallenge.org/specification.php
# Source Code: https://code.google.com/p/ai-contest/source/browse/#svn/trunk/planet_wars
require 'yaml'

require File.dirname(__FILE__) + '/./player.rb'
require File.dirname(__FILE__) + '/./order.rb'
require File.dirname(__FILE__) + '/./planet.rb'
require File.dirname(__FILE__) + '/./fleet.rb'
require File.dirname(__FILE__) + '/./player.rb'

class PlanetWars
  attr_reader :planets, :fleets, :filename, :steps, :max_steps, :player1, :player2
  attr_accessor :is_replay

  def initialize(filename = 'txt/state.txt', player1, player2)
    @filename = filename
    @steps = []
    @max_steps = MAX_TURN
    @is_replay = false
    @player1 = player1
    @player2 = player2
    @player1.pw = self
    @player2.pw = self
    game_state = File.open(filename, 'r').read
    read_state(game_state)
    @steps << {:fleets => [], :planets => @planets.map { |x| x.clone }}
  end

  def self.load_from_file(map_filename, state_filename)
    p1 = Player.new(1)
    p2 = Player.new(2)

    pw = PlanetWars.new(map_filename, p1, p2)
    pw.load_state(state_filename)
    pw.is_replay = true
    return pw
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

  def my_planets(player)
    @planets.select { |planet| planet.owner == player }
  end

  def neutral_planets
    @planets.select { |planet| planet.owner == 0 }
  end

  def enemy_planets(player)
    @planets.select { |planet| planet.owner == 3 - player }
  end

  def not_my_planets(player)
    @planets.reject { |planet| planet.owner == player }
  end

  def my_fleets(player)
    @fleets.select { |fleet| fleet.owner == player }
  end

  def enemy_fleets(player)
    @fleets.select { |fleet| fleet.owner == 3 - player }
  end

  def ships(player)
    res = 0
    @planets.select { |planet| planet.owner == player }.each { |p| res += p.num_ships }
    @fleets.select { |fleet| fleet.owner == player }.each { |f| res += f.num_ships }
    res
  end

  def score(player)
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
    return false if step < 0 || step > @max_steps || !is_alive(1) || !is_alive(2)
    return false if @is_replay && step >= @steps.length

    if step >= @steps.length
      while @steps.length <= step
        do_step
        fleets_clone = @fleets.map { |x| x.clone }
        planets_clone = @planets.map { |x| x.clone }
        @steps << {:fleets => fleets_clone, :planets => planets_clone}
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

    send_new_fleets 1, orders1
    send_new_fleets 2, orders2

    update_fleets
    update_planets
  end

  def send_new_fleets(no, orders)
    orders.each do |order|
      p1 = order.source
      p2 = order.dest
      num_ships = order.num_ships
      source = @planets[p1]
      dest = @planets[p2]
      d = source.distance(dest)
      t = source.travel_time(dest)
      @fleets << Fleet.new(self, no, num_ships, p1, p2, d, t)
      # source.num_ships -= num_ships
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

  def save_state(filename)
    File.open(filename, 'w').write(@steps.to_yaml)
  end

  def load_state(filename)
    @steps = YAML.load(File.open(filename, 'r').read)
  end

end