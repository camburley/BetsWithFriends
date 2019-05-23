class AddDayToBet < ActiveRecord::Migration[5.1]
  def change
    add_column :bets, :day, :string
  end
end
