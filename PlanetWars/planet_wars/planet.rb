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
