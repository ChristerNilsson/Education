class Planet
  attr_reader :id, :growth_rate, :x, :y
  attr_accessor :owner, :num_ships, :ships_left_in_current_turn

  def initialize(id, owner, num_ships, growth_rate, x, y)
    @id, @owner, @num_ships = id, owner, num_ships
    @growth_rate, @x, @y = growth_rate, x, y
  end

  def to_s
    "P #{x} #{y} #{owner} #{num_ships} #{growth_rate}"
  end

  def distance(destination)
    Math::hypot(self.x - destination.x, self.y - destination.y)
  end

  def travel_time(destination)
    distance(destination).ceil
  end
end
