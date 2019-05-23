class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :player_id
      t.string :name
      t.string :image
      t.string :position
      t.string :team
      t.timestamps
    end
  end
end
