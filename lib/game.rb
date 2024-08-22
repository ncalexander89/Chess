# frozen_string_literal: true

# game.rb

require_relative 'board'
require_relative 'rules'
require 'pry'

class Game # rubocop:disable Style/Documentation,Metrics/ClassLength
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

  def valid_move # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    @board.piece_positions[@piece].each do |pos| # **** this is calling piece positions
      @rules.move_positions[@piece].each do |valid_move|
        next unless @move_pos == [pos[0] + valid_move[0],
                                  pos[1] + valid_move[1]] && @board.board_array[@move_pos[0]][@move_pos[1]] == ' '

        next if @move[0] == 'p' && (pos[0] != 1 && pos[0] != 6) && (@move_pos[0] - pos[0]).abs == 2

        @current_pos = pos
        return true
      end
    end
    puts 'Enter a valid move'
    false
  end

  # def pawn
  #       @board.piece_positions[@piece].each do |pos| # **** this is calling piece positions

  # end

  def collision? # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    p steps = [@move_pos[0] - @current_pos[0], @move_pos[1] - @current_pos[1]]
    row = 0
    col = 0
    until row == steps[0] && col == steps[1]
      break if @move[0] == 'n'

      row += 1 if row < steps[0]
      row -= 1 if row > steps[0]
      col += 1 if col < steps[1]
      col -= 1 if col > steps[1]
      if @board.board_array[@current_pos[0] + row][@current_pos[1] + col] != ' '
        puts 'Collision!'
        return false
      end
    end
    true
  end

  def gameplay # rubocop:disable Metrics/MethodLength
    @board.board_display
    loop do
      loop do
        player_move
        move_translate
        break if valid_move && collision?
      end
      @board.board_update
      @board.board_display
      @turn += 1
    end
  end
end
