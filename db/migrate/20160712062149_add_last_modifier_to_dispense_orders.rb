class AddLastModifierToDispenseOrders < ActiveRecord::Migration
  def change
    add_column :dispense_orders, :last_modifier_type, :string, limit: 40
    add_column :dispense_orders, :last_modifier_id, :integer
  end
end
