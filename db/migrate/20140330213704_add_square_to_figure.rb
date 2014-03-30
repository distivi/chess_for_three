class AddSquareToFigure < ActiveRecord::Migration
  def change
    add_reference :figures, :square, index: true
  end
end
