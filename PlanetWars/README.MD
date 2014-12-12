# Planet Wars

Inspired by http://planetwars.aichallenge.org/

This is a robot challenge between two players. Your program will automatically send space ships to conquer other planets.

This judge is written in Ruby and assumes two robots written in any language.
The judge will execute the simulation and visualize the fight.

## The Robot

The robot will read a file containing state information. In response it will produce a file with attack orders.

A very simpled robot follows. All of your own planets will attack the closest enemy planet with all ships.

```
  my_planets.each do |source|
    dest = enemy_planets.sort_by {|p| distance(source,p)}.first
    issue_order(source.id, dest.id, source.num_ships)
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
* Travel time is one unit per turn.
* The robot has complete information about the state. E.g. position and sizes of all fleets and their targets are known.
* The winner is the player with largest total amount of ships on planets and in fleets.
* Maximum 200 turns.

## Requirements

* Ruby
* Chingu
* Gosu