# spec/models/frame_spec.rb

require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe '#ball_throw' do
    let(:game) { create(:game) }
    let(:frame) { create(:frame, game: game) }

    context 'when it is the first ball' do
      it 'handles a strike' do
        frame.ball_throw(10)
        expect(frame.throw_type).to eq('strike')
        expect(frame.bonus_ball).to eq(2)
      end

      it 'updates throw counters and score' do
        frame.ball_throw(7)
        expect(frame.current_throw).to eq(1)
        expect(frame.score).to eq(7)
      end
    end

    context 'when it is the second ball' do
      it 'handles a spare' do
        frame.update(score: 3, current_throw: 1) # Simulate previous throw
        frame.ball_throw(7)
        expect(frame.throw_type).to eq('spare')
        expect(frame.bonus_ball).to eq(1)
      end

      it 'updates throw counters and score' do
        frame.update(score: 3, current_throw: 1) # Simulate previous throw
        frame.ball_throw(7)
        expect(frame.current_throw).to eq(2)
        expect(frame.score).to eq(10) # Previous score + current throw
      end
    end

    context 'when the frame is finished' do
      it 'does not allow further throws' do
        frame.update(throws: 2, current_throw: 2)
        expect { frame.ball_throw(5) }.not_to change { frame.score }
      end
    end
  end

  describe '#update_frames_with_bonus' do
    let(:game) { create(:game) }
    let(:frame) { create(:frame, game: game, frame_index: 1) }
    let(:previous_frame) { create(:frame, game: game, frame_index: 0) }

    it 'updates the score of the previous frame with bonus points' do
      previous_frame.ball_throw(10)
      frame.ball_throw(5)

      expect(previous_frame.reload.score).to eq(15) # Previous score + bonus
    end
  end

  describe '#validate_knocked_pins' do
    let(:frame) { create(:frame) }

    context 'when it is the first ball' do
      it 'raises ArgumentError for invalid knocked pins' do
        expect { frame.validate_knocked_pins(11, true) }.to raise_error(ArgumentError)
      end
    end

    context 'when it is the second ball' do
      it 'raises ArgumentError for invalid knocked pins' do
        frame.update(score: 7) # Simulate previous throw
        expect { frame.validate_knocked_pins(5, false) }.to raise_error(ArgumentError)
      end
    end
  end
end
