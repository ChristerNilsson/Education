class MyBot < Player
  def do_turn
    return if my_fleets.length >= 3
    return if my_planets.length == 0
    return if not_my_planets.length == 0
    myplanets = my_planets.sort_by {|x| x.num_ships }
    other_planets = not_my_planets.sort_by {|x| 1.0/(1+x.num_ships) }
    source = myplanets[-1].id
    source_ships = myplanets[-1].num_ships
    dest = other_planets[-1].id
    if source >= 0 and dest >= 0
      num_ships = source_ships / 2
      issue_order(source, dest, num_ships)
    end
  end
end