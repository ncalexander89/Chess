# frozen_string_literal: true

# rules.rb

require_relative 'board'

class Rules # rubocop:disable Style/Documentation
  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def pawn(move); end
end
