require 'chingu'
require './planet_wars/planetwars.rb'
require './gui.rb'

MAP = 'map1'
PLAYER1 = 'Kobylin2'
PLAYER2 = 'Kobylin'

TRACE = false
MAP_PATH = "maps/#{MAP}.txt"
MAX_TURN = 200

require "./bots/#{PLAYER1.downcase}.rb"
require "./bots/#{PLAYER2.downcase}.rb" if PLAYER1 != PLAYER2

eval("class Player1 < #{PLAYER1}; end")
eval("class Player2 < #{PLAYER2}; end")


STATE_FILE = './saves/save01.yaml'

#Loading from saved file
def run_from_saved_state
  puts "Run game from file #{STATE_FILE}"
  pw = PlanetWars.load_from_file(MAP_PATH, STATE_FILE)
  GUI.new(1000, 1000, false, 200, pw).show
end

def run_realtime
  puts "Run game from realtime"
  player1 = Player1.new(1)
  player2 = Player2.new(2)
  pw = PlanetWars.new(MAP_PATH, player1, player2)
  GUI.new(1000, 1000, false, 200, pw, STATE_FILE).show
end

run_realtime
