# frozen_string_literal: true

# spec_chess.rb

require_relative '../lib/board'
require_relative '../lib/game'

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

describe Game do
  subject(:game) { Game.new }

  before do
    allow(game).to receive(:puts) # Avoid actual printing to console
  end

  context('When white to move pawn to invalid then valid position') do
    it('Updates the board') do
      allow(game).to receive(:gets).and_return('p', '5')
      game.instance_variable_set(:@turn, 1)
      expect(game).to receive(:puts).with('Player 1 select your column')
      expect(game).to receive(:puts).with('Enter a valid number')
      expect(game.player_turn).to eq(5)
      expect(game.instance_variable_get(:@selection)).to eq(5)
    end
  end
end
