class ChangeTables < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :options, :json, default: []
    
    rename_column :games, :user_id, :admin_id
    remove_column :games, :location, :string
    remove_column :games, :option_a, :string
    remove_column :games, :option_b, :string
  end
end
