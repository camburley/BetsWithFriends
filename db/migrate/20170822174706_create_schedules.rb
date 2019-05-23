class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      
      t.integer :week
      t.datetime :game_time
      t.string :away_team
      t.string :home_team

      t.timestamps
    end
  end
end
