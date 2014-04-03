class AddUntouchedToFigures < ActiveRecord::Migration
  def change
    add_column :figures, :untouched, :boolean, :default => true
  end
end
