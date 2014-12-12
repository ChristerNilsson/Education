# https://code.google.com/p/ai-contest/source/browse/#svn%253Fstate%253Dclosed
# http://planetwars.aichallenge.org/visualizer.php?game_id=9559558

require 'chingu'
require './planetwars.rb'

MAP = 'map1'
PLAYER1 = 'mybot'
PLAYER2 = 'ragebot'
BATCH = false

TRACE = false
MAP_PATH = "maps/#{MAP}.txt"
MAX_TURN = 200

def read_orders no
  lines = File.open("txt/cmd#{no}.txt",'r').readlines
  lines.map { |line| Order.new line }
end

def execute_player pw,no,orders
  orders.each do |order|
    p1 = order.source
    p2 = order.dest
    num_ships = order.num_ships
    source = pw.planets[p1]
    dest = pw.planets[p2]
    d = pw.distance(source, dest)
    t = pw.travel_time(source, dest)
    pw.fleets << Fleet.new(pw,no,num_ships,p1,p2,d,t)
    source.num_ships -= num_ships
    puts "Player #{no} fires #{num_ships} ships from #{p1} to #{p2}. Traveltime = #{t}" if TRACE
  end
end

def update_fleets pw # uppdatera fleets samt kolla de fleets som anlänt.
  pw.fleets.delete_if {|fleet| fleet.turns_remaining == -1}
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

def execute1 pw, iMap=0
  turn = 0
  orders = []
  cpu1 = []
  cpu2 = []
  while pw.is_alive(1) and pw.is_alive(2) and turn < MAX_TURN
    turn += 1

    File.open('txt/state.txt', 'w') { |f| f.puts "#{pw}" }

    t0 = Time.now
    system("ruby bots/#{PLAYER1}.rb 1")
    t1 = Time.now
    system("ruby bots/#{PLAYER2}.rb 2")
    t2 = Time.now

    orders1 = read_orders 1
    orders2 = read_orders 2

    execute_player pw,1,orders1
    execute_player pw,2,orders2

    update_fleets pw
    update_planets pw

    puts "Turn #{turn}: #{PLAYER1} :Blue #{pw.score(1)} - #{pw.score(2)} Red: #{PLAYER2} #{((t1-t0)*1000).round} ms #{((t2-t1)*1000).round} ms" if iMap==0
    cpu1 << ((t1-t0)*1000).round
    cpu2 << ((t2-t1)*1000).round

    orders << [orders1,orders2]
  end

  result = pw.ships(1) <=> pw.ships(2)
  txt= "#{PLAYER1} wins" if result==1
  txt= 'Draw' if result==0
  txt= "#{PLAYER2} wins" if result==-1
  puts "Map #{iMap} #{cpu1.max} ms #{cpu2.max} ms #{txt}"

  orders
end

def execute2 pw,orders,current_order
  turn = 0
  orders.each do |order|
    turn += 1
    break if turn > current_order

    execute_player pw,1,order[0]
    execute_player pw,2,order[1]

    update_fleets pw
    update_planets pw

  end

  $window.caption = "Planet War #{MAP} Turn #{turn}         Keys: Home Left Right End Space"

end

class GUI < Chingu::Window
  def initialize width=PIXELS,height=PIXELS,fullscreen=false,updateInterval=200, pw=nil, orders=[]
    super width,height,fullscreen,updateInterval
    @pw = pw
    @orders = orders
    @current_order = 0
    @scale=1.0
    @view = 0
    self.input = {:esc => :exit, :home => :begin, :end => :last, [:holding_n,:right] => :next_order, [:holding_p,:left] => :prev_order, :space => :toggle}
    self.caption = 'Planet Wars'
    execute2 @pw, @orders, @current_order
    xy = @pw.planets.map { |p| [p.x, p.y] }
    xs,ys = xy.transpose
    @xm = xs.minmax
    @ym = ys.minmax
    @xw = @xm[1]-@xm[0]
    @yh = @ym[1]-@ym[0]
  end
  def needs_cursor?
    true
  end
  def update
    super
  end
  def toggle
    @view = (@view+1) % 3
  end
  def position n
    return if n<0 or n == @orders.size
    @current_order = n
    @pw = PlanetWars.new(MAP_PATH)
    execute2 @pw, @orders, @current_order
  end
  def begin
    position 0
  end
  def last
    position @orders.size-2
  end
  def prev_order
    position @current_order - 1
  end
  def next_order
    position @current_order + 1
  end
  def _x(x)
    75+1000.0 * (x-@xm[0])/@xw*0.85
  end
  def _y(y)
    75+1000.0 * (y-@ym[0])/@yh*0.85
  end
  def draw_scores
    @text = Chingu::Text.new("#{PLAYER1}: #{@pw.score(1)}", :x => 0, :y=>10, :zorder=>5, :width => 30, :height => 50, :max_width => 300, :max_height=> 50, :align => :center, :color => Gosu::Color::BLUE)
    @text.draw
    @text = Chingu::Text.new("#{PLAYER2}: #{@pw.score(2)}", :x => 700, :y=>10, :zorder=>5, :width => 30, :height => 50, :max_width => 300, :max_height=> 50, :align => :center, :color => Gosu::Color::RED)
    @text.draw
  end
  def draw_planet planet
    color =  Gosu::Color::BLACK
    color =  Gosu::Color::BLUE if planet.owner==1
    color =  Gosu::Color::RED  if planet.owner==2
    fill_circle(_x(planet.x), _y(planet.y), 15 + 5.0*planet.growth_rate, color,9)
    draw_circle(_x(planet.x), _y(planet.y), 15 + 5.0*planet.growth_rate, Gosu::Color::BLACK,9)
    txt = planet.num_ships.to_s if @view == 0
    txt = planet.id if @view == 1
    txt = planet.growth_rate if @view == 2
    @text = Chingu::Text.new(txt, :x => _x(planet.x)-50, :y=>_y(planet.y)-15, :zorder=>10, :width => 30, :height => 30, :max_width => 100, :max_height=> 30, :align => :center, :color => Gosu::Color::YELLOW)
    @text.draw
  end
  def draw_fleet fleet
    return if fleet.turns_remaining == -1
    white = Gosu::Color::rgba(255,255,255,128)
    sz = 10 + 0.1*fleet.num_ships
    fill_circle(_x(fleet.x), _y(fleet.y), sz, white, 50)
    draw_circle(_x(fleet.x), _y(fleet.y), sz, Gosu::Color::YELLOW, 50)
    txt = fleet.num_ships.to_s
    color = fleet.owner == 1 ? Gosu::Color::BLUE : Gosu::Color::RED
    @text = Chingu::Text.new(txt, :x => _x(fleet.x)-50, :y=>_y(fleet.y)-12, :zorder=>55, :width => 30, :height => 24, :max_width => 100, :max_height=> 24, :align => :center, :color => color)
    @text.draw
    x1 = _x(fleet.x + sz * 0.02 * Math.cos(fleet.direction))
    y1 = _y(fleet.y + sz * 0.02 * Math.sin(fleet.direction))
    x2 = _x(fleet.x + sz * 0.04 * Math.cos(fleet.direction))
    y2 = _y(fleet.y + sz * 0.04 * Math.sin(fleet.direction))
    color2 = Gosu::Color::YELLOW
    draw_line x1, y1, color2, x2, y2, color2, 49
  end
  def draw
    fill_rect(Chingu::Rect.new(0,0,self.width,self.height),Gosu::Color::GRAY)
    draw_scores
    @pw.planets.each do |planet|
      draw_planet planet
    end
    @pw.fleets.each do |fleet|
      draw_fleet fleet
    end
  end
end

if BATCH
  0.times do |i|
    start = Time.now
    pw = PlanetWars.new("maps/map#{i+1}.txt")
    execute1 pw, i+1
    puts Time.now-start
  end
else
  pw = PlanetWars.new(MAP_PATH)
  orders = execute1 pw
  pw = PlanetWars.new(MAP_PATH)
  GUI.new(1000,1000,false,200,pw,orders).show
end