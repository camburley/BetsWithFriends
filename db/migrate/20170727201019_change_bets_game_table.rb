class ChangeBetsGameTable < ActiveRecord::Migration[5.1]
  def change
    add_column :bets, :validation_url, :string
    rename_column :games, :sport_type, :game_type
  end
end
