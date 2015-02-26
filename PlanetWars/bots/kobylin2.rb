class Kobylin2 < Player
  def do_turn
    my_planets.each do |source|
      arranged_planets = not_my_planets.sort_by {
          |x| -(x.growth_rate * 15 - source.distance(x) - x.num_ships)
      }
      arranged_planets.each do |dest|
        # next if my_fleets.select{}

        if source.num_ships >= dest.num_ships + 1 &&
            source.num_ships - dest.num_ships > 30

          issue_order(source, dest, dest.num_ships + 1)
        end
      end
    end

    already_sent_ships = []
    enemy_fleets.each do |fleet|
      attacked_planet = planets[fleet.dest]
      attacker = my_planets.select{|x|
        x.distance(attacked_planet) > fleet.turns_remaining &&
            x.distance(attacked_planet) < fleet.turns_remaining + 2
      }
      num_ships_to_attack = fleet.turns_remaining + attacked_planet.growth_rate * 2
      if attacker[0] && attacker[0].num_ships >= num_ships_to_attack
        issue_order(attacker[0], attacked_planet,  num_ships_to_attack)
        already_sent_ships << attacker[0]
      end
    end

  end
end