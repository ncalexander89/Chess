# frozen_string_literal: true

# board.rb

class Board # rubocop:disable Style/Documentation
  attr_accessor :board_array, :game_instance, :piece_positions

  def initialize(game_instance) # rubocop:disable Metrics/MethodLength
    @board_array = Array.new(8) { Array.new(8, ' ') } # First row at the top
    @game_instance = game_instance

    # Define orignal positions for all pieces
    @piece_positions = {
      '♙' => (0..7).map { |i| [1, i] }, # White pawns 0 -> [1,0], 1 -> [1,1] times 7 (cols)
      '♟' => (0..7).map { |i| [6, i] }, # Black pawns
      '♖' => [[0, 0], [0, 7]], # White rooks
      '♜' => [[7, 0], [7, 7]], # Black rooks
      '♗' => [[0, 2], [0, 5]], # White bishops
      '♝' => [[7, 2], [7, 5]], # Black bishops
      '♘' => [[0, 1], [0, 6]], # White knights
      '♞' => [[7, 1], [7, 6]], # Black knights
      '♔' => [[0, 4]],         # White king
      '♚' => [[7, 4]],         # Black king
      '♕' => [[0, 3]],         # White queen
      '♛' => [[7, 3]]          # Black queen
    }
    piece_put
  end

  # Goes through each piece position and plots on @board_array
  def piece_put
    @piece_positions.each do |piece, positions|
      positions.each { |row, col| @board_array[row][col] = piece }
    end
  end

  # Displays board according to @board_array
  def board_display
    puts '  ---------------------------------'
    @board_array.reverse.each_with_index do |row, index|
      puts "#{8 - index} | #{row.join(' | ')} |" # Join converts to string and separates with '|'
      puts '  ---------------------------------'
    end
    puts '    A   B   C   D   E   F   G   H  '
  end

  def update_piece_position
    # Updates @piece_positions hash, if the piece in question matches the current pos, then the piece pos is udpated to move_pos in @piece_positions
    @piece_positions[@game_instance.piece].map! { |sub| sub == @game_instance.current_pos ? @game_instance.move_pos : sub } # rubocop:disable Layout/LineLength
  end

  def board_update
    # piece is now where move_pos is in @board_array (called by board_display)
    @board_array[@game_instance.move_pos[0]][@game_instance.move_pos[1]] = @game_instance.piece
    # current pos is left empty in @board_array (called by board_display)
    @board_array[@game_instance.current_pos[0]][@game_instance.current_pos[1]] = ' '
  end

  def board_revert
    # piece is now where move_pos is in @board_array (called by board_display)
    @board_array[@game_instance.move_pos[0]][@game_instance.move_pos[1]] = ' '
    # current pos is left empty in @board_array (called by board_display)
    @board_array[@game_instance.current_pos[0]][@game_instance.current_pos[1]] = @game_instance.piece
  end
end
