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
    @move_pos = [@col, @row]
  end

  def gameplay
    @board.board_display
    # loop
    player_move
    move_translate
    # valid_move
    @board.board_update
    @board.board_display
  end
end
