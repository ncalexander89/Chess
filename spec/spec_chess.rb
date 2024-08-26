# frozen_string_literal: true

# spec_chess.rb

require_relative '../lib/board'
require_relative '../lib/game'

describe Game do # rubocop:disable Metrics/BlockLength
  subject(:game) { Game.new }

  before do
    allow(game).to receive(:puts) # Avoid actual printing to console
  end

  describe '#Player_move' do
    context('When player enters invalid then valid input') do
      it('Prompts for valid input and updates the board') do
        allow(game).to receive(:gets).and_return('p', 'pe4')
        expect(game).to receive(:puts).with('White to move')
        expect(game).to receive(:puts).with('Enter a valid input')
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

  describe '#Move_translate' do
    context 'When player enters valid input' do
      let(:move) { 'pe4' }

      it 'Translates the move into correct position' do
        expect(game.instance_variable_get(:@piece)).to eq('♙')
        expect(game.instance_variable_get(:@move_pos)).to eq([3, 4])
      end
    end
  end

  describe '#Valid_move' do # rubocop:disable Metrics/BlockLength
    let(:board) { Board.new(game) }
    before do
      game.valid_move
    end

    context 'When player enters a piece with an invalid move' do
      before do
        board.piece_positions # or similar method that initializes @piece_positions
      end
      it 'Prompts user for valid move' do
        game.instance_variable_set(:@piece, '♖')
        game.instance_variable_set(:@move_pos, [1, 1])
        expect(game).to receive(:puts).with('Enter a valid move')
        expect(game.valid_move).to be false
      end
    end

    context 'When player enters a piece with a valid move' do
      it 'Sets correct piece position and returns true' do
        game.instance_variable_set(:@piece, '♖')
        game.instance_variable_set(:@move_pos, [3, 0])
        expect(game.valid_move).to be true
      end
    end

    context 'When pawn attempts double jump not from starting pos' do
      it 'Sets correct piece position and returns true' do
        # If you need to use instance_variable_set,
        # it should only be used to set the entire @piece_positions
        # instance variable, not individual elements within it:
        board.piece_positions['♙'][0] = [4, 0]
        game.instance_variable_set(:@piece, '♙')
        game.instance_variable_set(:@move_pos, [6, 0])
        expect(game.valid_move).to be false
      end
    end

    context 'When pawn attempts double jump from starting pos' do
      it 'Sets correct piece position and returns true' do
        game.instance_variable_set(:@piece, '♙')
        game.instance_variable_set(:@move_pos, [3, 0])
        expect(game.valid_move).to be true
      end
    end
  end

  describe '#No collision' do
    before do
      game.instance_variable_set(:@move_pos, [7, 7])
      game.instance_variable_set(:@current_pos, [0, 0])
      game.no_collision?
    end

    context 'When there is a collision' do
      let(:board) { Board.new(game) }
      before do
        board_array = board.instance_variable_get(:@board_array)
        board_array[3][3] = '♘' # Place a piece to create a collision
        game.instance_variable_set(:@board_array, board_array)
      end
      it 'Prompts user for valid input' do
        expect(game).to receive(:puts).with('Collision!')
        expect(game.no_collision?).to be false
      end
    end

    context 'When there is no collision' do
      it 'Sets correct piece position and returns true' do
        game.instance_variable_set(:@move_pos, [3, 4])
        expect(game.valid_move).to be true
      end
    end
  end
end
