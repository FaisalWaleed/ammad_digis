class AddOngoingToDispenseOrders < ActiveRecord::Migration
  def change
    add_column :dispense_orders, :ongoing, :boolean, default: false, null: false
  end
end
