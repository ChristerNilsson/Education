class Order
  attr_accessor :source, :dest, :num_ships

  def initialize(source, dest, num_ships)
    @source = source
    @dest = dest
    @num_ships = num_ships
  end
end
