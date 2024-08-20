# frozen_string_literal: true

# spec_chess.rb

require_relative '../lib/board'
require_relative '../lib/game'

describe Game do # rubocop:disable Metrics/BlockLength
  subject(:game) { Game.new }

  before do
    allow(game).to receive(:puts) # Avoid actual printing to console
  end

  describe 'player_move' do
    context('When player enters invalid then valid input') do
      it('Prompts for valid input and updates the board') do
        allow(game).to receive(:gets).and_return('p', 'pe4')
        expect(game).to receive(:puts).with('White to move')
        expect(game).to receive(:puts).with('Enter a valid move')
        expect(game.player_move).to eq('pe4')
        expect(game.instance_variable_get(:@move)).to eq('pe4')
      end
    end
  end

  describe 'move_translate' do
    before do
      allow(game).to receive(:gets).and_return('pe4')
      game.player_move # Capture the move
      game.move_translate # Translate the move
    end

    context 'when player enters valid input' do
      let(:move) { 'pe4' }

      it 'translates the move into correct position' do
        expect(game.instance_variable_get(:@piece)).to eq('♙')
        expect(game.instance_variable_get(:@move_pos)).to eq([3, 4])
      end
    end
  end
end
