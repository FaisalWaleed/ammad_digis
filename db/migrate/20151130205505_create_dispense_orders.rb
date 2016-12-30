class CreateDispenseOrders < ActiveRecord::Migration
  def change
    create_table :dispense_orders do |t|
      t.integer :prescription_id
      t.integer :pharmacy_id
      t.integer :transferer_id

      t.timestamps null: false
    end
  end
end
