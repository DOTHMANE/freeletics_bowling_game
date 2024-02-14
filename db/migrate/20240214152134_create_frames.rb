class CreateFrames < ActiveRecord::Migration[7.1]
  def change
    create_table :frames do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :frame_index, default: 0
      t.integer :throws, default: 2
      t.integer :current_throw, default: 0
      t.integer :score, default: 0
      t.integer :throw_type, default: 0
      t.integer :bonus_ball, default: 0

      t.timestamps
    end
  end
end
