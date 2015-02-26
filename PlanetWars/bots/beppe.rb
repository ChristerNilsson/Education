class Beppe < Player
  def do_turn
    return if my_fleets.length >= 3
    return if my_planets.length == 0
    return if not_my_planets.length == 0
    source = my_planets.max_by {|x| x.num_ships }
    dest = not_my_planets.min_by {|x| source.distance(x) }
    if source.id >= 0 and dest.id >= 0
      issue_order(source, dest, dest.num_ships+1) if dest.num_ships+1 <= source.num_ships
    end
  end
end