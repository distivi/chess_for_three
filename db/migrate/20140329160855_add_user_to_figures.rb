class AddUserToFigures < ActiveRecord::Migration
  def change
    add_reference :figures, :user, index: true
  end
end
