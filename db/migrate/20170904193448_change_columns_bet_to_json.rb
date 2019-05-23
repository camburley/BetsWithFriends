class ChangeColumnsBetToJson < ActiveRecord::Migration[5.1]
  def change
    change_column :bets, :user_picked, 'json USING CAST(user_picked AS json)', default: []
    change_column :bets, :opponent_picked, 'json USING CAST(opponent_picked AS json)', default: []
  end
end
