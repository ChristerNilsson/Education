class Kobylin < Player

  def initialize(player)
    super
    @available_ships = {}
  end

  def do_turn
    @available_ships = {}
    my_planets.each do |planet|
      @available_ships[planet.id] = planet.num_ships
    end

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
          |x| -(x.growth_rate * 15 - distance(source, x) - x.num_ships)
      }

      arranged_planets.each do |dest|
        next if me_attack[dest.id] && me_attack[dest.id] > dest.num_ships

          if @available_ships[source.id] >= dest.num_ships + 1 #&&
            #@available_ships[source.id] - dest.num_ships > 50


            @available_ships[source.id] -= dest.num_ships + 1
            issue_order(source.id, dest.id, dest.num_ships + 1)
          end


      end
    end
  end
end