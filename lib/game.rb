# frozen_string_literal: true

# game.rb

require_relative 'board'

class Game # rubocop:disable Style/Documentation
  attr_accessor :board

  def initialize
    @board = Board.new
  end
end
