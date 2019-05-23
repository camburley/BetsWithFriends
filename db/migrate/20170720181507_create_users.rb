class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :profile_picture
      
      t.string :locale
      t.integer :timezone
      
      t.string :sender_id
      t.string :fb_id
      t.string :fb_token
      
      t.string :role

      t.timestamps
    end
  end
end
