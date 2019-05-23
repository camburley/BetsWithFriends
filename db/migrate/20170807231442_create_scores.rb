class CreateScores < ActiveRecord::Migration[5.1]
  def change
    create_table :scores do |t|
      t.belongs_to :player
      
      t.integer :games
      t.integer :pass_yards
      t.integer :touchdowns
      t.integer :interceptions
      t.integer :rush_yards
      t.integer :rush_touchdowns
      t.integer :receptions
      t.integer :reception_yards
      t.integer :reception_touchdowns
      t.integer :sacks
      t.integer :ppg
      t.integer :fantasy_points
      
      t.string :salary

      t.timestamps
    end
  end
end
