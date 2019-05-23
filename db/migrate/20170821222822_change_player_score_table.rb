class ChangePlayerScoreTable < ActiveRecord::Migration[5.1]
  def change
    remove_column :scores, :salary
    add_column :players, :salary, :json
    add_column :players, :prediction, :json
  end
end
