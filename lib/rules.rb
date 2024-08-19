# frozen_string_literal: true

# rules.rb

require_relative 'board'

class Rules # rubocop:disable Style/Documentation
  attr_accessor :board, :knight_moves, :move_positions

  def initialize # rubocop:disable Metrics/MethodLength
    @move_positions = {
      '♙' => [[2, 0], [1, 0]], # White pawn moves
      '♟' => [[2, 0], [1, 0]], # Black pawn moves
      '♖' => [[0, 7], [0, -7], [7, 0], [-7, 0]], # White rook moves
      '♜' => [[0, 7], [0, -7], [7, 0], [-7, 0]], # Black rook moves
      '♗' => [[7, 7], [-7, -7], [7, -7], [-7, 7]], # White bishop moves
      '♝' => [[7, 7], [-7, -7], [7, -7], [-7, 7]], # Black bishop moves
      '♘' => [[2, 1], [1, 2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, -2], [2, -1]], # White knight moves
      '♞' => [[2, 1], [1, 2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, -2], [2, -1]], # Black knight moves
      '♔' => [[0, 1], [1, 0], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]], # White king moves
      '♚' => [[0, 1], [1, 0], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]], # Black king moves
      '♕' => [[7, 7], [-7, -7], [7, -7], [-7, 7], [0, 7], [0, -7], [7, 0], [-7, 0]], # White queen moves
      '♛' => [[7, 7], [-7, -7], [7, -7], [-7, 7], [0, 7], [0, -7], [7, 0], [-7, 0]] # Black queen moves
    }
  end
end
