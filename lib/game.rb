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

  # def gameplay
  #   loop
  #     white
  #     return if checkmate
  #     black
  #     return if checkmate
  # end
end
