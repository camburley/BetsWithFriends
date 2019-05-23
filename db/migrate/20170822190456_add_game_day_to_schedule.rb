class AddGameDayToSchedule < ActiveRecord::Migration[5.1]
  def change
    add_column :schedules, :game_day, :integer
  end
end
