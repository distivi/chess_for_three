class AddColotFourUserAndDeleteRoom < ActiveRecord::Migration
  def change
  	add_column :users, :color, :integer
  	remove_reference :users, :room
  end
end
