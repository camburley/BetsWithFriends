class AddScoreWeekToBet < ActiveRecord::Migration[5.1]
  def change
    add_column :bets, :week, :integer
    add_column :bets, :user_score, :string
    add_column :bets, :opponent_score, :string
  end
end
