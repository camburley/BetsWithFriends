class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      
      t.string :first_name
      t.string :last_name
      t.string :provider
      t.string :fb_id
      t.string :fb_token
      t.string :profile_picture
      
      t.string :role

      t.timestamps
    end
  end
end
