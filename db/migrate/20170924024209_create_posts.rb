class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :post_id
      t.string :question
      t.json :answer, default: []
      t.json :message, default: []
      t.json :winners, default: []

      t.timestamps
    end
  end
end
