class AddOpponentToPlayer < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :opponent, :string
  end
end
