# frozen_string_literal: true

# spec_chess.rb

require_relative '../lib/board'
require_relative '../lib/game'

# describe Board do
#   subject(:board) { Board.new }

#   before do
#     allow(board).to receive(:puts) # Avoid actual printing to console
#   end

#   context('When user enters valid input') do
#     it('Updates the board') do
#       expect(board)
#     end
#   end
# end

describe Game do
  subject(:game) { Game.new }

  before do
    allow(game).to receive(:puts) # Avoid actual printing to console
  end

  context('When white moves pawn to invalid then valid position') do
    it('Updates the board') do
      allow(game).to receive(:gets).and_return('p', 'pe4')
      expect(game).to receive(:puts).with('White to move')
      expect(game).to receive(:puts).with('Enter a valid move')
      expect(game.white).to eq('pe4')
      expect(game.instance_variable_get(:@move)).to eq('pe4')
    end
  end

  context('When white enters valid move') do
    it('Transalates the move into correct piece and coordinates') do
      allow(game.move_translate(move)).to receive(:@move).and_return('pe4')
      expect(game.instance_variable_get(:@col)).to eq(4)
    end
  end

end
