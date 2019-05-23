class AddResultToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :result, :string
  end
end
