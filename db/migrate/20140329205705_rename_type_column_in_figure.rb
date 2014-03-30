class RenameTypeColumnInFigure < ActiveRecord::Migration
  def change
  	rename_column :figures, :type, :figure_type
  end
end
