# frozen_string_literal: true

# game.rb

require_relative 'board'

class Game # rubocop:disable Style/Documentation
  attr_accessor :board, :turn, :move, :piece, :row

  def initialize
    @board = Board.new(self)
    @turn = 1
    @move = nil
    @piece = nil
    @row = nil
  end

  def white
    puts 'White to move'
    loop do
      input = gets.chomp
      # Input match single digit from 1 to 7 and available position
      if input.match?(/^[prbnkq](d[a-h]|[a-h])?(x)?[a-h][1-8]$/)
        @move = input
        return @move
      else
        puts 'Enter a valid move'
      end
    end
  end

  def valid_move
    p chess_piece
    @kinight_moves = [[2, 1], [1, 2], [-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, -2], [2, -1]]

  end

  def black
    puts 'Black to move'
    loop do
      input = gets.chomp
      # Input match single digit from 1 to 7 and available position
      if input.match?(/^[prbnkq](d[a-h]|[a-h])?(x)?[a-h][1-8]$/)
        @move = input
        return @move
      else
        puts 'Enter a valid move'
      end
    end
  end

  # turn into array?
  def chess_piece(move_piece)
    if @turn.odd?
      piece = '♙' if move_piece == 'p'
      piece = '♖' if move_piece == 'r'
      piece = '♗' if move_piece == 'b'
      piece = '♘' if move_piece == 'n'
      piece = '♕' if move_piece == 'q'
      piece = '♔' if move_piece == 'k'
    else
      piece = '♟' if move_piece == 'p'
      piece = '♜' if move_piece == 'r'
      piece = '♝' if move_piece == 'b'
      piece = '♞' if move_piece == 'n'
      piece = '♛' if move_piece == 'q'
      piece = '♚' if move_piece == 'k'
    end
    piece
  end

  def coords(move_col) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    return 0 if move_col == 'a'
    return 1 if move_col == 'b'
    return 2 if move_col == 'c'
    return 3 if move_col == 'd'
    return 4 if move_col == 'e'
    return 5 if move_col == 'f'
    return 6 if move_col == 'g'
    return 7 if move_col == 'h'
  end

  # pe4, pxe4, pde4, pdxe4
  def move_translate(move)
    # return true if move.include?('x')
    @col = coords(move[-2])
    @row = (move[-1]).to_i - 1
    @piece = chess_piece(move[0])
  end

  # moves piece in same column

  def gameplay
    @board.board_display
    # loop
    @turn.odd? ? move_translate(white) : move_translate(black)
    # valid_move
    @board.board_update
    @board.board_display

    # return if checkmate
    # black
    # return if checkmate
  end
end
