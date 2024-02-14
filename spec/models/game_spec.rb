# spec/models/game_spec.rb

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '#roll' do
    let(:game) { create(:game) }
    let(:frame) { create(:frame, game: game) }

    context 'when the frame is finished' do
      it 'simulates a roll and updates current frame' do
        expect(game.current_frame).to eq(0)
        game.roll(5)
        game.roll(5)
        expect(game.current_frame).to eq(1) # No increment since the frame is not finished
      end
    end

    context 'when the frame is finished' do
      it 'does not simulate further rolls' do
        expect { game.roll(5) }.not_to change { game.current_frame }
      end
    end
  end

  describe '#finished?' do
    let(:game) { create(:game) }

    context 'when the game is finished' do
      it 'returns true' do
        allow(game).to receive(:current_frame).and_return(10)
        expect(game.finished?).to eq(true)
      end
    end

    context 'when the game is not finished' do
      it 'returns false' do
        allow(game).to receive(:current_frame).and_return(9)
        expect(game.finished?).to eq(false)
      end
    end
  end

  describe '#score' do
    let(:game) { create(:game) }

    it 'calculates the total score of the game' do
      allow(game.frames).to receive(:sum).with(:score).and_return(100)
      expect(game.score).to eq(100)
    end
  end

  describe '#get_current_frame' do
    let(:game) { create(:game) }

    context 'when there are no frames' do
      it 'creates a new frame and returns it' do
        expect(game.frames.count).to eq(0)
        expect(game.get_current_frame).to be_an_instance_of(Frame)
        expect(game.frames.count).to eq(1)
      end
    end

    context 'when the last frame is finished' do
      it 'creates a new frame and returns it' do
        create(:frame, game: game, current_throw: 2, throws: 2) # Simulate finished frame
        expect(game.frames.count).to eq(1)
        expect(game.get_current_frame).to be_an_instance_of(Frame)
        expect(game.frames.count).to eq(2)
      end
    end

    context 'when the last frame is not finished' do
      it 'returns the last frame' do
        create(:frame, game: game, current_throw: 1, throws: 2) # Simulate unfinished frame
        expect(game.frames.count).to eq(1)
        expect(game.get_current_frame).to be_an_instance_of(Frame)
        expect(game.frames.count).to eq(1)
      end
    end
  end
end
