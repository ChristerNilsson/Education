require 'chingu'
require './planet_wars/planetwars.rb'
require './gui.rb'

MAP = 'map1'
PLAYER1 = 'Kobylin'
PLAYER2 = 'RageBot'
BATCH = 0

TRACE = false
MAP_PATH = "maps/#{MAP}.txt"
MAX_TURN = 200

require "./bots/#{PLAYER1.downcase}.rb"
require "./bots/#{PLAYER2.downcase}.rb" if PLAYER1 != PLAYER2

eval("class Player1 < #{PLAYER1}; end")
eval("class Player2 < #{PLAYER2}; end")


save_file = './saves/save01.yaml'

player1 = Player1.new(1)
player2 = Player2.new(2)
pw = PlanetWars.new(MAP_PATH, player1, player2)
# pw.load_state(save_file)
GUI.new(1000, 1000, false, 200, pw).show