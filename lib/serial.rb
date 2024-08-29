# frozen_string_literal: true

# serial.rb

require_relative 'board'
require_relative 'game'

class GameSerializer # rubocop:disable Style/Documentation
  attr_accessor :game, :turn

  require 'yaml'

  def save_game(filename, game_instance)
    yaml_data = {
      turn: game_instance.turn,
      piece_positions: game_instance.board.piece_positions
    }.to_yaml

    File.write(filename, yaml_data)
  end

  def load_game(filename)
    yaml_string = File.read(filename)
    from_yaml(yaml_string)
  end

  def from_yaml(yaml_string)
    data = YAML.load(yaml_string) # Safe load for untrusted data, seems to cause issues
    game = Game.new
    game.turn = data[:turn]
    game.board.piece_positions = data[:piece_positions]
    game.board.game_instance = game
    game
  end
end
