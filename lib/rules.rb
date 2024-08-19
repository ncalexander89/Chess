# frozen_string_literal: true

# rules.rb

require_relative 'board'

class Rules # rubocop:disable Style/Documentation
  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def pawn(move)
    if move[0] == 1
      @pawn_moves = [[0, 2], [0, 1]]
    end
    if move.include?('x')
      @pawn_moves = [[0, 2], [0, 1], [1, 1], [-1, 1]]
    end
    @pawn_moves = [[0, 1]]
  end

  def knight(move)
    @knight_moves = [[2, 1], [1, 2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, -2], [2, -1]]
  end

  def rook(move)
    @rook_moves = [[0, 7], [0, -7], [7, 0], [-7, 0]]
  end

  def king(move)
    @king_moves = [[0, 1], [1, 0], [1, 1], [-1, 0], [0, -1], [-1, -1], [1, -1], [-1, 1]]
  end

  def queen(move)
    @queen_moves = [[7, 7], [-7, -7], [7, -7], [-7, 7], [0, 7], [0, -7], [7, 0], [-7, 0]]
  end

  def bishop(move)
    @bishop_moves = [[7, 7], [-7, -7], [7, -7], [-7, 7]]
  end
end
