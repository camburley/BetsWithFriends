class RenameValidationToAccepted < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :validation_url, :string
    rename_column :bets, :validation_url, :accepted
    change_column :bets, :accepted, 'boolean USING CAST(accepted AS boolean)'
  end
end
