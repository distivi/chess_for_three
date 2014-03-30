class AddDeskToSquares < ActiveRecord::Migration
  def change
    add_reference :squares, :desk, index: true
  end
end
