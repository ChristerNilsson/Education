# Planet Wars

Inspired by http://planetwars.aichallenge.org/

See http://planetwars.aichallenge.org/visualizer.php?game_id=9559558

This is a robot challenge between two players. Your program will automatically send space ships to conquer other planets.

This judge is written in Ruby and assumes the robots to be written in Ruby.
The judge will execute the simulation and visualize the fight.

## Keys
Right = Next Turn
Left  = Previous Turn
Space = Toggle between ships and planet ids.
Home = Go to First Turn
End  = Go to Last Turn

## The Robot

The robot will read a file containing state information. In response it will produce a file with attack orders.

A very simple robot follows. All of your own planets will attack the closest enemy planet with all ships available.

```
    my_planets.each do |source|
      dest = enemy_planets.min_by {|p| distance(source,p)}
      issue_order(source.id, dest.id, source.num_ships) if source.num_ships >= 10 * source.growth_rate
    end
```

## API

```
class Player
  def issue_order(source,dest,ships)
  def orders
  def planets
  def fleets
  def my_planets
  def my_fleets
  def enemy_fleets
  def enemy_planets
  def not_my_planets
  def distance source,dest
end

class Fleet
  attr_reader :owner, :num_ships, :source, :dest, :total_trip_length, :turns_remaining
end

class Planet
  attr_reader :id, :growth_rate, :x, :y, :owner, :num_ships
end
```

## State File Example (state.txt)

Planet with x, y, owner, number of ships, growth_rate

P 19.46 20.05 0 35 5

Fleet with owner, number of ships, source, destination, trip_length, turns_remaining

F 1 65 2 5 22.18 15

## Order file Example (cmd1.txt, cmd2.txt)

Attack from source planet 3 against destination planet 4 using 5 ships.

3 4 5

## Rules

* Maximum one second wall time per turn.
* Planets owned by players will produce a number of ships at every turn, see growth_rate.
* Neutral planets (owner=0) will not produce ships until they are conquered.
* Several orders can be issued in one turn.
* An order can not be altered once issued.
* Travel time is one unit per turn.
* The robot has complete information about the state. E.g. position and sizes of all fleets and their targets are known.
* The winner is the player with the largest total amount of ships on planets and in fleets.
* Maximum 200 turns.

## Requirements

* Ruby 1.9.3
* Chingu 0.9
* Gosu 0.7.5

## Tips

* Try to put at least one ship on planets with high growth rate and not too far away.
* Reposition ships between your own planets to be able to respond quicker.
* Use travel time and growth rate to calculate how many ships you need to attack.
* Try to syncronize attacks from several planets.
