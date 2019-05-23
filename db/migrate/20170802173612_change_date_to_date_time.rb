class ChangeDateToDateTime < ActiveRecord::Migration[5.1]
  def change
    change_column :games, :start_date, :datetime
    change_column :games, :expiration_date, :datetime
    change_column :bets, :expiration_date, :datetime
  end
end
