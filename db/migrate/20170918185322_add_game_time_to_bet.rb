class AddGameTimeToBet < ActiveRecord::Migration[5.1]
  def change
    add_column :bets, :game_time, :datetime
  end
end
