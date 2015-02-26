class Test < Player
  def do_turn
    if my_planets[0] && not_my_planets[0]
      issue_order(my_planets[0], not_my_planets[0], 1000)
    end
  end
end