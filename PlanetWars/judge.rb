# https://code.google.com/p/ai-contest/source/browse/#svn%253Fstate%253Dclosed
# http://planetwars.aichallenge.org/visualizer.php?game_id=9559558

require 'chingu'
require './planet_wars/planetwars.rb'
require './gui.rb'

MAP = 'map1'
PLAYER1 = 'Kobylin'
PLAYER2 = 'RageBot'
BATCH = 0

TRACE = false
MAP_PATH = "maps/#{MAP}.txt"
MAX_TURN = 200

require "./bots/#{PLAYER1.downcase}.rb"
require "./bots/#{PLAYER2.downcase}.rb" if PLAYER1 != PLAYER2

eval("class Player1 < #{PLAYER1}; end")
eval("class Player2 < #{PLAYER2}; end")

class Judge

  def initialize filename
    # @pw = PlanetWars.new(filename)
    @player1 = Player1.new(@pw, 1)
    @player2 = Player2.new(@pw, 2)
  end

  def execute_player pw, no, orders
    orders.each do |order|
      p1 = order.source
      p2 = order.dest
      num_ships = order.num_ships
      source = pw.planets[p1]
      dest = pw.planets[p2]
      d = pw.distance(source, dest)
      t = pw.travel_time(source, dest)
      pw.fleets << Fleet.new(pw, no, num_ships, p1, p2, d, t)
      source.num_ships -= num_ships
      puts "Player #{no} fires #{num_ships} ships from #{p1} to #{p2}. Traveltime = #{t}" if TRACE
    end
  end

  def update_fleets pw # uppdatera fleets samt kolla de fleets som anlänt.
    pw.fleets.delete_if { |fleet| fleet.turns_remaining == -1 }
    pw.fleets.each do |fleet|
      if fleet.turns_remaining == 0
        planet = pw.planets[fleet.dest]
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

  def update_planets pw # låt planeterna föda nya ships. Gäller ej neutrala planeter.
    pw.planets.each do |planet|
      next if planet.owner == 0
      planet.num_ships += planet.growth_rate
      puts "Planet #{planet.id} grows to #{planet.num_ships} ships. Owner #{planet.owner}" if TRACE
    end
  end

  def execute1 iMap=0
    turn = 0
    orders = []
    cpu1 = []
    cpu2 = []
    start = Time.now
    while @pw.is_alive(1) and @pw.is_alive(2) and turn < MAX_TURN
      turn += 1

      t0 = Time.now
      @player1.do_turn
      t1 = Time.now
      @player2.do_turn
      t2 = Time.now

      orders1 = @player1.orders
      orders2 = @player2.orders

      execute_player @pw, 1, orders1
      execute_player @pw, 2, orders2

      update_fleets @pw
      update_planets @pw

      puts "Turn #{turn}: #{@pw.score(1)} - #{@pw.score(2)}" if iMap==0
      cpu1 << ((t1-t0)*1000).round
      cpu2 << ((t2-t1)*1000).round

      orders << [orders1, orders2]
    end

    result = @pw.ships(1) <=> @pw.ships(2)
    txt= "#{PLAYER1} wins" if result==1
    txt= 'Draw' if result==0
    txt= "#{PLAYER2} wins" if result==-1
    puts "Map#{iMap} #{txt} #{@pw.score(1)} - #{@pw.score(2)} #{cpu1.max} ms #{cpu2.max} ms #{(Time.now-start).round(1)} sec."

    orders
  end

  def execute2 pw, orders, current_order
    turn = 0
    orders.each do |order|
      turn += 1
      break if turn > current_order

      execute_player pw, 1, order[0]
      execute_player pw, 2, order[1]

      update_fleets pw
      update_planets pw

    end

    $window.caption = "Planet War #{MAP} Turn #{turn}         Keys: Home Left Right End Space"

  end


  # def find list
  #   Dir['maps/*'].each do |f|
  #     pw = PlanetWars.new(f)
  #     lst = list.clone
  #     pw.planets.each { |planet| lst.delete(planet.num_ships) }
  #     puts "#{pw.filename} #{pw.planets.size}" if lst==[]
  #   end
  # end

end



#find [78,34,60] # söker bland alla kartfiler efter planeternas num_ships

if BATCH == 0
  # judge = Judge.new MAP_PATH
  # orders = judge.execute1
  save_file = './saves/save01.yaml'
  player1 = Player1.new(1)
  player2 = Player2.new(2)
  pw = PlanetWars.new(MAP_PATH, player1, player2)
  # pw.load_state('./saves/save01.yaml')
  GUI.new(1000, 1000, false, 200, pw).show
else
  BATCH.times do |i|
    judge = Judge.new "maps/map#{i+1}.txt"
    judge.execute1 i+1
  end
end