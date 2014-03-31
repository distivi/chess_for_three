class AddColumnUserWalkethIdToDesks < ActiveRecord::Migration
  def change
    add_column :desks, :user_walketh_id, :integer
  end
end
