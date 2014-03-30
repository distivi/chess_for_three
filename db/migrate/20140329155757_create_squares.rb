class CreateSquares < ActiveRecord::Migration
  def change
    create_table :squares do |t|
      t.string :name

      t.timestamps
    end
  end
end
