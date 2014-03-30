class AddDeskToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :desk, index: true
  end
end
