class AddPlayersToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :player_white_id, :integer
    add_index :rooms, :player_white_id
    add_column :rooms, :player_black_id, :integer
    add_index :rooms, :player_black_id
    add_column :rooms, :player_red_id, :integer
    add_index :rooms, :player_red_id
  end
end
