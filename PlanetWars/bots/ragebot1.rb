require './planetwars.rb'

def do_turn(pw)
  pw.my_planets.each do |source|
    #next if source.num_ships < 10 * source.growth_rate
    dest = pw.enemy_planets.sort_by {|p| pw.distance(source,p)}.first
    pw.issue_order(source.id, dest.id, source.num_ships-1) if dest != nil
  end
end

pw = PlanetWars.new()
do_turn(pw)
pw.send_orders

