class AddMerchantIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :merchant_id, :string, limit: 255
  end
end
