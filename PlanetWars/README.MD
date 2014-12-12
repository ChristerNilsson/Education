Planet Wars
===========

Inspired by http://planetwars.aichallenge.org/

This a robot challenge between two players. Your program will automatically send space ships to conquer other planets.
All file formats are specified at the site above.

This judge is written in Ruby and assumes two robots written in any language.
The judge will execute the simulation and visualize the fight.

The Robot
=========
The robot will read a file containing state information. In response it will produce a file with attack orders.

State File Example
==================
P 19.4667873213 20.0561682576 0 35 5 # Planet with owner, number of ships, growth_rate, x, y
F 1 65 2 5 22.182199770273648 15 # Fleet with owner, number of ships, source, destination, trip_length, turns_remaining

Order file Example
==================
3 4 5  # Attack planet 4 from planet 2 using 5 ships.

Requirements
============
Ruby
Chingu
Gosu