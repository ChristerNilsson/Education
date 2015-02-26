class GUI < Chingu::Window
  def initialize(width=PIXELS, height=PIXELS, fullscreen=false, updateInterval=200, pw=nil, save_to=nil)
    super width, height, fullscreen, updateInterval
    # @judge = judge
    @pw = pw
    @save_to = save_to
    # @orders = orders
    @current_order = 0
    @current_state = pw.execute 0
    @scale=1.0
    @view = 0
    self.input = {
        :esc => :exit,
        :home => :begin,
        :end => :last,
        [:holding_n, :right] => :next_order,
        [:holding_p, :left] => :prev_order,
        :space => :toggle,
        :p => :play
    }
    self.caption = 'Planet Wars'
    # @judge.execute2 @pw, @orders, @current_order
    xy = @pw.planets.map { |p| [p.x, p.y] }
    xs, ys = xy.transpose
    @xm = xs.minmax
    @ym = ys.minmax
    @xw = @xm[1]-@xm[0]
    @yh = @ym[1]-@ym[0]
    @game_finished = false
  end

  def needs_cursor?
    true
  end

  def update
    super
  end

  def toggle
    @view = (@view+1) % 4
  end

  def play
    Thread.new do
      while !@game_finished
        next_order
        sleep(1)
      end
    end
  end

  def position (n)
    # return if n<0 or n == @orders.size
    @current_order = n
    # @pw = PlanetWars.new(MAP_PATH)
    puts @current_order
    state = @pw.execute @current_order
    if state === false
      finish_game
    else
      @current_state = state
    end
    # @judge.execute2 @pw, @orders, @current_order
  end

  def finish_game
    @game_finished = true
    @pw.save_state(@save_to) if @save_to != nil
    self.input = {}
    puts 'game finished'
  end

  def begin
    position 0
  end

  def last
    # i = 0
    while !@game_finished
      next_order
      # i+=1
    end
  end

  def prev_order
    if @current_order > 0
      position @current_order - 1
    end
  end

  def next_order
    return if @game_finished
    position @current_order + 1
  end

  def _x(x)
    75+1000.0 * (x-@xm[0])/@xw*0.85
  end

  def _y(y)
    1000-(75+1000.0 * (y-@ym[0])/@yh*0.85)
  end

  def draw_scores
    @text = Chingu::Text.new("#{PLAYER1}: #{score(1)}", :x => 0, :y => 10, :zorder => 5, :width => 30, :height => 50, :max_width => 300, :max_height => 50, :align => :center, :color => Gosu::Color::RED)
    @text.draw
    @text = Chingu::Text.new("#{PLAYER2}: #{score(2)}", :x => 700, :y => 10, :zorder => 5, :width => 30, :height => 50, :max_width => 300, :max_height => 50, :align => :center, :color => Gosu::Color::BLUE)
    @text.draw
    @text = Chingu::Text.new("Step: #{@current_order}",
                             :x => 0, :y => self.height - 50,
                             :zorder => 5,
                             :width => 30, :height => 50,
                             :max_width => 300, :max_height => 50,
                             :align => :center, :color => Gosu::Color::BLUE)
    @text.draw
  end

  def num_score(player)
    growth = 0
    @current_state[:planets].select { |planet| planet.owner == player }.each do |p|
      growth += p.growth_rate
    end
    ships = 0
    @current_state[:planets].select { |planet| planet.owner == player }.each { |p| ships += p.num_ships }
    @current_state[:fleets].select { |fleet| fleet.owner == player }.each { |f| ships += f.num_ships }
    ships + 2 * growth
  end

  def score(player)
    growth = 0
    @current_state[:planets].select { |planet| planet.owner == player }.each do |p|
      growth += p.growth_rate
    end
    ships = 0
    @current_state[:planets].select { |planet| planet.owner == player }.each { |p| ships += p.num_ships }
    @current_state[:fleets].select { |fleet| fleet.owner == player }.each { |f| ships += f.num_ships }
    "#{ships}/#{growth}"
  end

  def draw_planet(planet)
    color = Gosu::Color::GRAY
    color = Gosu::Color::RED if planet.owner==1
    color = Gosu::Color::BLUE if planet.owner==2
    fill_circle(_x(planet.x), _y(planet.y), 15 + 5.0*planet.growth_rate, color, 9)
    # draw_circle(_x(planet.x), _y(planet.y), 15 + 5.0*planet.growth_rate, Gosu::Color::BLACK, 9)
    txt = planet.num_ships.to_s if @view == 0
    txt = planet.id if @view == 1
    txt = planet.growth_rate if @view == 2
    #txt = (pw.distance(pw.planets[1], planet) + 1.0 * (planet.num_ships) / planet.growth_rate).round if @view == 3
    @text = Chingu::Text.new(txt.to_s, :x => _x(planet.x)-50, :y => _y(planet.y)-15, :zorder => 10, :width => 30, :height => 30, :max_width => 100, :max_height => 30, :align => :center, :color => Gosu::Color::YELLOW)
    @text.draw
  end

  def draw_fleet(fleet)
    return if fleet.turns_remaining == -1
    white = Gosu::Color::rgba(255, 255, 255, 128)
    color = fleet.owner == 2 ? Gosu::Color::BLUE : Gosu::Color::RED
    sz = 10 + 0.1*fleet.num_ships
    fill_circle(_x(fleet.x), _y(fleet.y), sz, white, 50)
    draw_circle(_x(fleet.x), _y(fleet.y), sz, color, 50)
    txt = fleet.num_ships.to_s
    @text = Chingu::Text.new(txt, :x => _x(fleet.x)-50, :y => _y(fleet.y)-12, :zorder => 55, :width => 30, :height => 24, :max_width => 100, :max_height => 24, :align => :center, :color => Gosu::Color::YELLOW)
    @text.draw
    x1 = _x(fleet.x + sz * 0.02 * Math.cos(fleet.direction))
    y1 = _y(fleet.y + sz * 0.02 * Math.sin(fleet.direction))
    x2 = _x(fleet.x + sz * 0.04 * Math.cos(fleet.direction))
    y2 = _y(fleet.y + sz * 0.04 * Math.sin(fleet.direction))
    color2 = Gosu::Color::YELLOW
    draw_line x1, y1, color2, x2, y2, color2, 49
  end

  def game_over_message
    width = 400
    height = 200
    @text = Chingu::Text.new('Game Over',
                             :x => self.width/2 - width,
                             :y => self.height/2 - height,
                             :zorder => 100,
                             :width => width,
                             :height => height,
                             :align => :center,
                             :color => Gosu::Color::YELLOW
    )
    @text.draw
    win_msg=''
    if num_score(1) == num_score(2)
      win_msg='Same score!'
    elsif num_score(1) > num_score(2)
      win_msg='Player 1 wins!'
    elsif num_score(1) < num_score(2)
      win_msg='Player 2 wins!'
    end

    @text = Chingu::Text.new(win_msg,
                             :x => self.width/2 - width + 50,
                             :y => self.height/2,
                             :zorder => 100,
                             :width => width - 50,
                             :height => height-50,
                             :align => :center,
                             :color => Gosu::Color::YELLOW
    )
    @text.draw
  end

  def draw
    fill_rect(Chingu::Rect.new(0, 0, self.width, self.height), Gosu::Color::BLACK)
    draw_scores
    @current_state[:planets].each do |planet|
      draw_planet planet
    end
    @current_state[:fleets].each do |fleet|
      draw_fleet fleet
    end
    if @game_finished
      game_over_message
    end
  end
end
