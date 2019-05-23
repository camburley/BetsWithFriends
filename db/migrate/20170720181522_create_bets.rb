class CreateBets < ActiveRecord::Migration[5.1]
  def change
    create_table :bets do |t|
      t.belongs_to :user
      t.belongs_to :game
      
      t.string :wage
      t.string :user_picked
      t.string :opponent_picked
      t.integer :opponent
      
      t.date :expiration_date
      
      t.boolean :closed, :default => false
      t.boolean :notifications, :default => false
      t.boolean :resolved, :default => false
      
      t.integer :winner

      t.timestamps
    end
  end
end
