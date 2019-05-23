class AddBudgetToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :budget, :integer
  end
end
