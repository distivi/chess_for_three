class AddWaitingStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_waiting, :boolean
  end
end
