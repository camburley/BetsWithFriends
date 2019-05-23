class CreateLikables < ActiveRecord::Migration[5.1]
  def change
    create_table :likables do |t|
      t.belongs_to :user_id
      
      t.integer :likable_id
      t.string :likable_type
      t.string :result

      t.timestamps
    end
  end
end
