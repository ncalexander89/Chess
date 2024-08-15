# frozen_string_literal: true

# board.rb

class Board # rubocop:disable Style/Documentation
  attr_accessor :board_array

  def initialize # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    @board_array = Array.new(8) { Array.new(8, ' ') } # First row at the top
    @board_array[6] = Array.new(8, '♟') # Set entire second row to ♟
    @board_array[1] = Array.new(8, '♙') # Set entire second row to ♙
    @board_array[0][0] = '♖'
    @board_array[0][7] = '♖'
    @board_array[7][7] = '♜'
    @board_array[7][0] = '♜'
    @board_array[0][1] = '♗'
    @board_array[0][6] = '♗'
    @board_array[7][1] = '♝'
    @board_array[7][6] = '♝'
    @board_array[0][2] = '♘'
    @board_array[0][5] = '♘'
    @board_array[7][2] = '♞'
    @board_array[7][5] = '♞'
    @board_array[0][4] = '♔'
    @board_array[0][3] = '♕'
    @board_array[7][4] = '♚'
    @board_array[7][3] = '♛'
  end

  def board_display
    puts '  ---------------------------------'
    @board_array.reverse.each_with_index do |row, index|
      puts "#{8 - index} | #{row.join(' | ')} |" # Join converts to string and separates with '|'
      puts '  ---------------------------------'
    end
    puts '    A   B   C   D   E   F   G   H  '
  end

  def board_update(move); end
end
