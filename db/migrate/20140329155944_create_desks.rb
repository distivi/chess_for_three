class CreateDesks < ActiveRecord::Migration
  def change
    create_table :desks do |t|

      t.timestamps
    end
  end
end
