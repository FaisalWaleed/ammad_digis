class AddTransferredAtToDispenseOrders < ActiveRecord::Migration
  def change
    add_column :dispense_orders, :transferred_at, :datetime
  end
end
