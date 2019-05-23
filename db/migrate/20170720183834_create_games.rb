class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.belongs_to :user
      
      t.string :sport_type
      
      t.string :title
      t.string :description
      t.string :image
      
      t.string :option_a
      t.string :option_b
      
      t.date :start_date
      t.date :expiration_date
      
      t.string :location

      t.timestamps
    end
  end
end
