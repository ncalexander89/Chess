# frozen_string_literal: true
# 
require_relative 'board'
require_relative 'game'

class GameSerializer # rubocop:disable Style/Documentation
  attr_accessor :game, :turn

  require 'yaml'

  def save_game(filename, game_instance)
    yaml_data = {
      # board: game_instance.board.board_array,
      turn: game_instance.turn,
      piece_positions: game_instance.board.piece_positions
    }.to_yaml

    File.write(filename, yaml_data)
  end

  def load_game(filename)
    yaml_string = File.read(filename)
    from_yaml(yaml_string)
  end

  def from_yaml(yaml_string) # rubocop:disable Metrics/AbcSize
    # data = YAML.safe_load(yaml_string, permitted_classes: [Symbol])
    data = YAML.load(yaml_string)


    # data = data.transform_keys(&:to_sym) if data.keys.first.is_a?(String)

    game = Game.new

    # board = Board.new(game)
    game.turn = data[:turn]
    # game.board.board_array = data[:board_array]
    game.board.piece_positions = data[:piece_positions]
    # Board.new(game).board_update
    game.board.game_instance = game

    game
  end
end
