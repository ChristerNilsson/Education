class Elite < Player
  def initialize player
    @orders = []
    @player = player
    @sent_to = []
    @do_turn_counter = 0
  end
  
  def do_turn
    # myplanets = my_planets.sort_by {|x| x.num_ships }
    other_planets = not_my_planets.sort_by { |x| x.num_ships }

    ships_left = {}
    my_planets.each do |source|
      ships_left[source.id] = source.num_ships
      other_planets.each do |dest|
        # if (@sent_to.index(dest) == nil)
          if ships_left[source.id] >= dest.num_ships+1
            issue_order(source.id, dest.id, dest.num_ships+1)
            ships_left[source.id] = ships_left[source.id] - (dest.num_ships+1)
            # @sent_to.push(dest)
          end
        # end
      end

    end

    # @do_turn_counter += 1
    # if @do_turn_counter > 10
    #   @sent_to.clear
    #   @do_turn_counter = 0
    # end
    #source_ships = myplanets[-1].num_ships

  end
end
