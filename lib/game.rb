# frozen_string_literal: true

# game.rb

require_relative 'board'

class Game # rubocop:disable Style/Documentation
  attr_accessor :board, :turn, :move

  def initialize
    @board = Board.new
    @turn = 1
    @move = nil
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

  def chess_piece(move_piece)
    piece = '♙' if move_piece == 'p'
    piece = '♖' if move_piece == 'r'
    piece = '♗' if move_piece == 'b'
    piece = '♘' if move_piece == 'n'
    piece = '♕' if move_piece == 'q'
    piece = '♔' if move_piece == 'k'
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
  def move_translate(move) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    return unless @turn.odd?
    return true if move.include?('x')

    col = coords(move[-2])
    @row = (move[-1]).to_i - 1
    @piece = chess_piece(move[0])
    # p @piece
    @board.board_array.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        if cell == @piece && col_index == col
          position = [row_index, col_index]
          p @board.board_array[@row][position[1]] = [@piece]
          @board.board_array[position[0]][position[1]] = ' '
        end
      end
    end


    # p destination = move[-2..]
    # p @board.board_array[1][4]

    false
  end

  def gameplay
    @board.board_display
    # loop
    move_translate(white)
    @board.board_display

    # return if checkmate
    # black
    # return if checkmate
  end
end
