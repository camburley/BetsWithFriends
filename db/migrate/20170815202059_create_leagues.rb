class CreateLeagues < ActiveRecord::Migration[5.1]
  def change
    create_table :leagues do |t|
      t.belongs_to :user
      t.column :players, :json, default: []
      t.string :title

      t.timestamps
    end
  end
end
