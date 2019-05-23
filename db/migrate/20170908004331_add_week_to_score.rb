class AddWeekToScore < ActiveRecord::Migration[5.1]
  def change
    add_column :scores, :week, :integer
  end
end
