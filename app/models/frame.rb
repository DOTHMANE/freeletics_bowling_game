class Frame < ApplicationRecord
  belongs_to :game

  enum throw_type: { normal: 0, spare: 1, strike: 2 }

  # Method to record a throw in the frame
  def ball_throw(knocked_pins)
    return if finished?

    if is_first_ball?
      handle_first_ball(knocked_pins)
    else
      handle_second_ball(knocked_pins)
    end

    increment_throw_counters(knocked_pins)
    update_frames_with_bonus(knocked_pins) unless is_first_frame?
  end

  # Method to handle logic for the first ball of the frame
  def handle_first_ball(knocked_pins)
    validate_knocked_pins(knocked_pins, true)
    if knocked_pins == 10
      update(throw_type: :strike, bonus_ball: 2)
      increment!(:throws, -1) unless is_last_frame?
    end
  end

  # Method to handle logic for the second ball of the frame
  def handle_second_ball(knocked_pins)
    validate_knocked_pins(knocked_pins, false)
    if knocked_pins + score == 10
      update(throw_type: :spare, bonus_ball: 1)
    end
  end

  # Method to increment throw counters and update score
  def increment_throw_counters(knocked_pins)
    increment!(:current_throw, 1)
    increment!(:score, knocked_pins)
  end

  # Method to update frames with bonus points
  def update_frames_with_bonus(knocked_pins)
    previous_frame = get_previous_frame(self)
    return if previous_frame.nil?

    update_score_of_previous_frame(previous_frame, knocked_pins)

    update_score_of_previous_frame(get_previous_frame(previous_frame), knocked_pins) unless previous_frame.is_first_frame?
  end

  # Method to update the score of the previous frame with bonus points
  def update_score_of_previous_frame(previous_frame, knocked_pins)
    if previous_frame.bonus_ball.positive?
      previous_frame.decrement!(:bonus_ball)
      previous_frame.increment!(:score, knocked_pins)
    end
  end

  # Method to get the previous frame
  def get_previous_frame(frame)
    return nil if frame.is_first_frame?

    game.frames.find_by(frame_index: frame.frame_index - 1)
  end

  # Method to check if the frame has finished
  def finished?
    current_throw == throws
  end

  # Method to check if the frame is the first frame of the game
  def is_first_frame?
    frame_index.zero?
  end

  # Method to check if the frame is the last frame of the game
  def is_last_frame?
    frame_index == 9
  end

  # Method to check if it's the first ball of the frame
  def is_first_ball?
    current_throw.zero?
  end

  # Method to validate the number of knocked pins
  def validate_knocked_pins(knocked_pins, first_ball)
    if first_ball
      unless knocked_pins.between?(0, 10)
        raise ArgumentError, 'Number of knocked pins must be between 0 and 10 for the first ball'
      end
    else
      if is_last_frame?
        validate_last_frame_pins(knocked_pins)
      else
        rest_pins = 10 - score
        unless knocked_pins.between?(0, rest_pins)
          raise ArgumentError, 'Number of knocked pins must be between 0 and remaining pins'
        end
      end
    end
  end

  # Method to validate the number of knocked pins for the last frame
  def validate_last_frame_pins(knocked_pins)
    if score >= 10
      unless knocked_pins.between?(0, 10)
        raise ArgumentError, 'Number of knocked pins must be between 0 and 10 for the last frame'
      end
    else
      rest_pins = 10 - score
      unless knocked_pins.between?(0, rest_pins)
        raise ArgumentError, 'Number of knocked pins must be between 0 and remaining pins'
      end
    end
  end
end
