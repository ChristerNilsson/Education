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
