class GameSerializer < ActiveModel::Serializer
  has_many :frames

  attributes :game_score
  def game_score
    object.score
  end
end
