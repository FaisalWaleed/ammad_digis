class AddMarchantCustomerIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :merchant_customer_id, :string, limit: 255
  end
end
