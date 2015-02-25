class RageBot < Player
  def do_turn
    my_planets.each do |source|
      dest = enemy_planets.min_by {|p| distance(source,p)}
      issue_order(source.id, dest.id, source.num_ships) if source.num_ships >= 10 * source.growth_rate
    end
  end
end
