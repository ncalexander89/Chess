# frozen_string_literal: true

# rules.rb

require_relative 'board'

class Rules # rubocop:disable Style/Documentation
  attr_accessor :board, :knight_moves, :move_positions

  def initialize # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    # flat_map: This method is useful because it flattens the arrays
    # created inside the block into a single array, so there's no need to
    # concatenate multiple arrays manually.
    @move_positions = {
      '♙' => [[2, 0], [1, 0]], # White pawn moves
      '♟' => [[-2, 0], [-1, 0]], # Black pawn moves
      '♖' => (1..7).flat_map { |i| [[i, 0], [-i, 0], [0, i], [0, -i]] }, # 1..7 is the iterations
      '♜' => (1..7).flat_map { |i| [[i, 0], [-i, 0], [0, i], [0, -i]] }, # Black rook moves
      '♗' => (1..7).flat_map { |i| [[i, i], [-i, i], [-i, -i], [i, -i]] }, # White bishop moves
      '♝' => (1..7).flat_map { |i| [[i, i], [-i, i], [-i, -i], [i, -i]] }, # Black bishop moves
      '♘' => [[2, 1], [1, 2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, -2], [2, -1]], # White knight moves
      '♞' => [[2, 1], [1, 2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, -2], [2, -1]], # Black knight moves
      '♔' => [[0, 1], [1, 0], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]], # White king moves
      '♚' => [[0, 1], [1, 0], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]], # Black king moves
      '♕' => (1..7).flat_map { |i| [[i, i], [-i, i], [-i, -i], [i, -i], [i, 0], [-i, 0], [0, i], [0, -i]] }, # White queen moves # rubocop:disable Layout/LineLength
      '♛' => (1..7).flat_map { |i| [[i, i], [-i, i], [-i, -i], [i, -i], [i, 0], [-i, 0], [0, i], [0, -i]] } # Black queen moves # rubocop:disable Layout/LineLength
    }
  end
end
