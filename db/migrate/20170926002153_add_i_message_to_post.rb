class AddIMessageToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :i_message, :json, default: []
    add_column :posts, :answer_taken, :json, default: []
  end
end
