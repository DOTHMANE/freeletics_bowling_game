class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.integer :current_frame, default: 0

      t.timestamps
    end
  end
end
