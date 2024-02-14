FactoryBot.define do
  factory :frame do
    game

    throws { 2 }
    current_throw { 0 }
    score { 0 }
    frame_index { 0 }
  end
end
