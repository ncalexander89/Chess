# frozen_string_literal: true

# game.rb

require_relative 'board'
require_relative 'rules'
require 'pry'

class Game # rubocop:disable Style/Documentation
  attr_accessor :board, :turn, :move, :piece, :row, :rules, :move_pos, :current_pos

  def initialize
    @board = Board.new(self)
    @rules = Rules.new
    @turn = 1
    @move = nil
    @piece = nil
    @row = nil
    @move_pos = nil
    @current_pos = nil
  end

  def player_move
    puts @turn.odd? ? 'White to move' : 'Black to move'
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

  # hash mapping
  def chess_piece(move_piece) # rubocop:disable Metrics/MethodLength
    pieces = if @turn.odd?
               {
                 'p' => '♙',
                 'r' => '♖',
                 'b' => '♗',
                 'n' => '♘',
                 'q' => '♕',
                 'k' => '♔'
               }
             else
               {
                 'p' => '♟',
                 'r' => '♜',
                 'b' => '♝',
                 'n' => '♞',
                 'q' => '♛',
                 'k' => '♚'
               }
             end
    @piece = pieces[move_piece]
  end

  # hash mapping
  def coords(move_col) # rubocop:disable Metrics/MethodLength
    column_map = {
      'a' => 0,
      'b' => 1,
      'c' => 2,
      'd' => 3,
      'e' => 4,
      'f' => 5,
      'g' => 6,
      'h' => 7
    }
    column_map[move_col]
  end

  def move_translate
    @col = coords(@move[-2])
    @row = (@move[-1]).to_i - 1
    @piece = chess_piece(@move[0])
    @move_pos = [@row, @col]
  end

  def valid_move
    @board.piece_positions[@piece].each do |pos|
      @rules.knight_moves.each do |valid_move|
        if @move_pos == [pos[0] + valid_move[0], pos[1] + valid_move[1]]
          @current_pos = pos
          return true
        end
      end
    end
    puts 'Enter a valid move'
    false
  end

  def gameplay
    @board.board_display
    loop do
      player_move
      move_translate
      break if valid_move
    end
    @board.board_update
    @board.board_display
  end
end
