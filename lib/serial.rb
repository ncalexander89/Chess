# frozen_string_literal: true

# serial.rb

require_relative 'board'
require_relative 'game'

class GameSerializer # rubocop:disable Style/Documentation
  attr_accessor :game, :turn

  require 'yaml'

  # Sends the instance of game and specifies which data to save, to_yaml converts to YAML formatted string
  def save_game(filename, game_instance)
    yaml_data = {
      turn: game_instance.turn,
      piece_positions: game_instance.board.piece_positions
    }.to_yaml

    File.write(filename, yaml_data) # Writes to data filename in YAML formatted string
  end

  # Loads the YAML formatted string from the filename and sends it to from_yaml function
  def load_game(filename)
    yaml_string = File.read(filename)
    from_yaml(yaml_string)
  end

  # YAML.load(yaml_string): This method parses the YAML-formatted string and converts it back into a Ruby hash
  # (or whatever data structure was serialized).
  def from_yaml(yaml_string)
    data = YAML.load(yaml_string) # Safe load for untrusted data, seems to cause issues # rubocop:disable Security/YAMLLoad
    game = Game.new # Intialises Game object
    game.turn = data[:turn] # New turn value from data hash
    game.board.piece_positions = data[:piece_positions] # New piece position from data hash
    game # Returns game with newly assigned values to load_game
  end
end
