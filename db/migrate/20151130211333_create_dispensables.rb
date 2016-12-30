class CreateDispensables < ActiveRecord::Migration
  def change
    create_table :dispensables do |t|
      t.integer :dispense_order_id
      t.integer :prescript_id

      t.timestamps null: false
    end
  end
end
