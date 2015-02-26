class Kobylin < Player

  def do_turn
    my_planets.each do |source|
      me_attack = {}
      mine_attacked = {}

      my_fleets.each do |fleet|
        me_attack[fleet.dest] = 0 if me_attack[fleet.dest] == nil
        me_attack[fleet.dest] += fleet.num_ships
      end

      enemy_fleets.each do |fleet|
        mine_attacked[fleet.dest] = 0 if mine_attacked[fleet.dest] == nil
        mine_attacked[fleet.dest] += fleet.num_ships
      end

      arranged_planets = not_my_planets.sort_by {
          |x| -(x.growth_rate * 15 - source.distance(x) - x.num_ships)
      }

      arranged_planets.each do |dest|
        next if me_attack[dest.id] && me_attack[dest.id] > dest.num_ships

          if source.num_ships >= dest.num_ships + 1 &&
              source.num_ships - dest.num_ships > 50

            issue_order(source, dest, dest.num_ships + 1)
          end
      end
    end
  end
end