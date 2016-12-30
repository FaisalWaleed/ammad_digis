class CreateDispensations < ActiveRecord::Migration
  def change
    create_table :dispensations do |t|
      t.integer :dispensable_id
      t.decimal :price, precision: 10, scale: 2
      t.integer :pharmacist_id

      t.timestamps null: false
    end
  end
end
