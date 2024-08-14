# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { Board.new }

  before do
    allow(board).to receive(:puts) # Avoid actual printing to console
  end

  context('When user enters valid input') do
    it('Updates the board') do
      expect(board)
    end
  end
end
