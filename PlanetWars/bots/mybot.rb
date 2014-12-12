require './planetwars.rb'

def do_turn(pw)
  return if pw.my_fleets.length >= 3
  return if pw.my_planets.length == 0
  return if pw.not_my_planets.length == 0
  my_planets = pw.my_planets.sort_by {|x| x.num_ships }
  other_planets = pw.not_my_planets.sort_by {|x| 1.0/(1+x.num_ships) }
  source = my_planets[-1].id
  source_ships = my_planets[-1].num_ships
  dest = other_planets[-1].id
  if source >= 0 and dest >= 0
    num_ships = source_ships / 2
    pw.issue_order(source, dest, num_ships)
  end
end

pw = PlanetWars.new()
do_turn(pw)
pw.send_orders