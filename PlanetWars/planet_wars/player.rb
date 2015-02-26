class Player
  attr_accessor :pw

  def initialize(player)
    @orders = []
    @player = player
  end

  def issue_order(source, dest, ships)
    if ships > source.num_ships
      ships = source.num_ships
    end
    return if ships <=0
    @orders << Order.new(source.id, dest.id, ships.round)
    source.num_ships -= ships
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
    @pw.enemy_fleets @player
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
end
