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

  before do
    allow(game).to receive(:gets).and_return('pe4')
    game.player_move # Capture the move
    game.move_translate # Translate the move
  end

  describe 'move_translate' do
    context 'when player enters valid input' do
      let(:move) { 'pe4' }

      it 'translates the move into correct position' do
        expect(game.instance_variable_get(:@piece)).to eq('♙')
        expect(game.instance_variable_get(:@move_pos)).to eq([3, 4])
      end
    end
  end

  describe 'valid_move' do
    before do
      game.valid_move
    end

    context 'when player enters an invalid position' do
      it 'prompts user for valid input' do
        game.instance_variable_set(:@move_pos, [1, 1])
        expect(game).to receive(:puts).with('Enter a valid move')
        expect(game.valid_move).to be false
      end
    end

    context 'when player enters a valid position' do
      it 'sets correct piece position and returns true' do
        game.instance_variable_set(:@move_pos, [3, 4])
        expect(game.instance_variable_get(:@current_pos)).to eq([1, 4])
        expect(game.valid_move).to be true
      end
    end
  end

  describe 'collision' do
    before do
      game.instance_variable_set(:@move_pos, [7, 7])
      game.instance_variable_set(:@current_pos, [0, 0])
      game.collision?
    end

    context 'when there is a collision' do
      let(:board) { Board.new(game) }
      before do
        board_array = board.instance_variable_get(:@board_array)
        board_array[3][3] = '♘' # Place a piece to create a collision
        game.instance_variable_set(:@board_array, board_array)
      end
      it 'prompts user for valid input' do
        expect(game).to receive(:puts).with('Collision!')
        expect(game.collision?).to be false
      end
    end

    context 'when it is a valid move' do
      it 'sets correct piece position and returns true' do
        game.instance_variable_set(:@move_pos, [3, 4])
        expect(game.valid_move).to be true
      end
    end
  end
end
