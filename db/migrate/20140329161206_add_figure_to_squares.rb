class AddFigureToSquares < ActiveRecord::Migration
  def change
    add_reference :squares, :figure, index: true
  end
end
