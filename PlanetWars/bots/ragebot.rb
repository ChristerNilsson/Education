class RageBot < Player
  def do_turn
    my_planets.each do |source|
      dest = enemy_planets.min_by {|p| source.distance(p)}
      issue_order(source, dest, source.num_ships) if source.num_ships >= 10 * source.growth_rate
    end
  end
end
