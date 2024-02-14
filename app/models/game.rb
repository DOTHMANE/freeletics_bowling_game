class Game < ApplicationRecord
  has_many :frames

  # Method to simulate a roll in the game
  def roll(knocked_pins)
    return if finished?

    current_frame = get_current_frame

    current_frame.ball_throw(knocked_pins)

    increment!(:current_frame, 1) if current_frame.finished?
  end

  # Method to check if the game has finished
  def finished?
    current_frame == 10
  end

  # Method to calculate the total score of the game
  def score
    frames.sum(:score)
  end

  private

  # Method to get the current frame of the game
  def get_current_frame
    last_frame = frames.last

    if last_frame.nil? || last_frame.finished?
      last_frame = frames.create(frame_index: current_frame)
      last_frame.increment!(:throws, 1) if last_frame.is_last_frame?
    end

    last_frame
  end
end
