# frozen_string_literal: true

# game.rb

require_relative 'board'
require_relative 'rules'
require_relative 'serial'
# require 'pry'
require 'yaml'

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

  def player_move # rubocop:disable Metrics/MethodLength
    puts @turn.odd? ? 'White to move' : 'Black to move'
    loop do
      input = gets.chomp
      # Input match single digit from 1 to 7 and available position
      if input == '$'
        GameSerializer.new.save_game('saved_game.yaml', self) # calls class method save_game
        puts "\nGame Saved\n"
      end
      if input.match?(/^[prbnkq](d[a-h]|[a-h])?(x)?[a-h][1-8]$/)
        @move = input
        return @move # do we need to return move?
      else
        puts 'Enter a valid input'
      end
    end
  end

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

  def valid_move # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity
    @board.piece_positions[@piece].each do |pos| # this is calling piece positions
      @rules.move_positions[@piece].each do |valid_move|
        # If player input is a valid move
        next unless @move_pos == [pos[0] + valid_move[0], pos[1] + valid_move[1]]

        # Skips piece is pawn trying to double jump and not on first or 6th row
        next if @move[0] == 'p' && (pos[0] != 1 && pos[0] != 6) && (@move_pos[0] - pos[0]).abs == 2

        @current_pos = pos
        return true
      end
    end
    puts 'Enter a valid move'
    false
  end

  def check? # rubocop:disable Metrics/AbcSize
    # If the piece that was just moved has a next move position where the king 
    # of the opposite colour is with no collisions
    @rules.move_positions[@piece].each do |valid_move|
      check_move = [@move_pos[0] + valid_move[0], @move_pos[1] + valid_move[1]]
      if (@turn.odd? && check_move == @board.piece_positions['♚'][0]) || (@turn.even? && check_move == @board.piece_positions['♔'][0])
        current_pos = @move_pos
        if no_collision?(check_move, current_pos)
          return true
        end
      end
    end
    false
  end

  def no_collision?(move_pos, current_pos) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    # If trying to move to a space that is taken
    unless (@board.board_array[move_pos[0]][move_pos[1]] == '♚') || (@board.board_array[move_pos[0]][move_pos[1]] == '♔')
      if !@move.include?('x') && @board.board_array[move_pos[0]][move_pos[1]] != ' '
        puts 'x needed to capture'
        return false
      end
    end

    steps = [move_pos[0] - current_pos[0], move_pos[1] - current_pos[1]]
    row = 0
    col = 0
    loop do
      return true if @move[0] == 'n'

      row += 1 if row < steps[0]
      row -= 1 if row > steps[0]
      col += 1 if col < steps[1]
      col -= 1 if col > steps[1]

      return true if row == steps[0] && col == steps[1]

      if @board.board_array[current_pos[0] + row][current_pos[1] + col] != ' '
        # puts 'Collision!'
        return false
      end
    end
  end

  def capture # rubocop:disable Metrics/AbcSize
    return true unless @move.include?('x') # seems weird
    return true if @turn.odd? && @rules.black.include?(@board.board_array[@move_pos[0]][@move_pos[1]][0])

    true if @turn.even? && @rules.white.include?(@board.board_array[@move_pos[0]][@move_pos[1]][0])
  end

  def gameplay # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    @board.piece_put
    @board.board_display
    puts 'Welcome to Chess!'
    puts 'Load previous game Y/N?'
    load_input = gets.chomp.downcase
    until %w[y n].include?(load_input)
      puts 'Please enter Y or N'
      load_input = gets.chomp.downcase
    end

    if load_input == 'y'
      game_serializer = GameSerializer.new
      loaded_game = game_serializer.load_game('saved_game.yaml')
      @turn = loaded_game.turn # Loads saved game turn from data hash
      @board.piece_positions = loaded_game.board.piece_positions # Loads saved piece positions from data hash
      @board.piece_put
      @board.board_display
    end
    puts 'Enter $ anytime to save game'
    loop do
      loop do
        player_move
        move_translate
        break if valid_move && no_collision?(@move_pos, @current_pos) && capture
      end
      @board.board_update
      @board.board_display
      puts 'Check!' if check?
      @turn += 1
    end
  end
end
