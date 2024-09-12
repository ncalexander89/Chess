# frozen_string_literal: true

# game.rb

require_relative 'board'
require_relative 'rules'
require_relative 'serial'
require 'pry'
require 'yaml'

class Game # rubocop:disable Style/Documentation,Metrics/ClassLength
  attr_accessor :board, :turn, :move, :piece, :rules, :move_pos, :current_pos, :check_move, :check_black_king, :check_white_king, :check_possible

  def initialize # rubocop:disable Metrics/MethodLength
    @board = Board.new(self)
    @rules = Rules.new
    @turn = 1
    @move = nil
    @piece = nil
    @move_pos = nil
    @current_pos = nil
    @in_check = false
    @check_move = nil
    @check_black_king = false
    @check_white_king = false
    @check_possible = false
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
        return true # do we need to return move?
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
    col = coords(@move[-2])
    row = (@move[-1]).to_i - 1
    @piece = chess_piece(@move[0])
    @move_pos = [row, col]
  end

  def valid_move # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    @board.piece_positions[@piece].each do |pos| # this is calling piece positions
      @rules.move_positions[@piece].each do |valid_move|
        # If player input is a valid move
        next unless @move_pos == [pos[0] + valid_move[0], pos[1] + valid_move[1]]

        # Skips piece if pawn trying to double jump and not on first or 6th row
        next if @move[0] == 'p' && (pos[0] != 1 && pos[0] != 6) && (@move_pos[0] - pos[0]).abs == 2

        # Stores the piece position in questions as @current_pos
        @current_pos = pos
        # Sends the @move_pos and @current_pos to check if collision
        # binding.pry
        # p @board.board_array[@move_pos[0]][@move_pos[1]][0]
        return true if no_collision?(@move_pos,
                                     @current_pos) || (@move[0] == 'n' && (@board.board_array[@move_pos[0]][@move_pos[1]][0]) == ' ') # rubocop:disable Layout/LineLength
      end
    end
    # If no pieces match the @move
    puts 'Enter a valid move'
    false
  end

  def black_king_check? # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    @rules.white.each do |piece| # Go through each piece
      @board.piece_positions[piece].each do |pos| # Go through each current position of each piece
        @rules.move_positions[piece].each do |valid_move| # Go through each move position of each piece
          check_move = [pos[0] + valid_move[0], pos[1] + valid_move[1]] # Final move position
          next unless check_move == @board.piece_positions['♚'][0]

          @check_possible = true
          next unless no_collision?(check_move, pos)

          @check_black_king = true
          puts 'Check Black King!'
          return true
        end
      end
    end
    @check_black_king = false
    @check_possible = false
    false
  end

  def white_king_check? # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    @rules.black.each do |piece| # Go through each piece
      @board.piece_positions[piece].each do |pos| # Go through each current position of each piece
        @rules.move_positions[piece].each do |valid_move| # Go through each move position of each piece
          check_move = [pos[0] + valid_move[0], pos[1] + valid_move[1]] # Final move position
          next unless check_move == @board.piece_positions['♔'][0]

          @check_possible = true
          next unless no_collision?(check_move, pos)

          @check_white_king = true
          # binding.pry
          puts "Can't move into Check!"
          return true
        end
      end
    end
    @check_white_king = false
    @check_possible = false
    false
  end

  def no_collision?(move_pos, current_pos) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    # return true if @move[0] == 'n' && @check_possible == false

    # 'Check' method calls collision so make sure if its a potential check that it doesnt pass through 'x need to capture'
    # If trying to move to a space that is taken and not a capture
    if (@check_possible == false) && (!@move.include?('x') && @board.board_array[@move_pos[0]][@move_pos[1]] != ' ')
      puts 'x needed to capture'
      return false
    end

    # Number of steps in row and col
    steps = [move_pos[0] - current_pos[0], move_pos[1] - current_pos[1]]
    row = 0
    col = 0
    loop do
      # break if @move[0] == 'n'

      row += 1 if row < steps[0]
      row -= 1 if row > steps[0]
      col += 1 if col < steps[1]
      col -= 1 if col > steps[1]

      # Gets to end position without collision
      return true if row == steps[0] && col == steps[1]

      if @board.board_array[current_pos[0] + row][current_pos[1] + col] == '♔'
        # puts "Can't move into Check!"
        return false

      elsif @board.board_array[current_pos[0] + row][current_pos[1] + col] != ' '
        puts 'Collision!'
        return false
      end
    end
    true
  end

  def capture # rubocop:disable Metrics/AbcSize
    return true unless @move.include?('x') # seems weird
    return true if @turn.odd? && @rules.black.include?(@board.board_array[@move_pos[0]][@move_pos[1]][0])

    return true if @turn.even? && @rules.white.include?(@board.board_array[@move_pos[0]][@move_pos[1]][0])

    false
  end

  def gameplay # rubocop:disable Metrics/MethodLength,Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
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
      @board.board_array = Array.new(8) { Array.new(8, ' ') } # Clears board_array so loaded pieces aren't loaded on top
      @board.piece_positions = loaded_game.board.piece_positions # Loads saved piece positions from data hash
      @board.piece_put
      @board.board_display
    end
    puts 'Enter $ anytime to save game'
    loop do
      loop do
        player_move # @move
        move_translate # @piece, @move_pos
        # @current_pos
        next unless valid_move && capture # Goes back to start of loop if either false

        @board.board_update
        # Move into check
        if (@turn.odd? && white_king_check?) || (@turn.even? && black_king_check?)
          # binding.pry

          # @current_pos, @move_pos = @move_pos, @current_pos

          # @board.board_update
          @board.board_revert
          # @board.update_piece_position
          @board.piece_put

          # binding.pry

          @check_white_king = false
          @check_black_king = false
          next
        end
        break
      end
      @board.update_piece_position
      @board.board_update
      @board.board_display
      # puts 'Check!' if white_king_check? || black_king_check?
      @turn += 1
    end
  end
end
