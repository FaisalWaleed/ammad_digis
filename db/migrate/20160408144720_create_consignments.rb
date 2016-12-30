class CreateConsignments < ActiveRecord::Migration
  def change
    create_table :consignments do |t|
      t.integer :dispense_order_id
      t.integer :dispensable_id

      t.timestamps null: false
    end
  end
end
