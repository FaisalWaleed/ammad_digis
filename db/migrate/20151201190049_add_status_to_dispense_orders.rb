class AddStatusToDispenseOrders < ActiveRecord::Migration
  def change
    add_column :dispense_orders, :processing_at, :datetime
    add_column :dispense_orders, :ready_at, :datetime
    add_column :dispense_orders, :delivered_at, :datetime
  end
end
