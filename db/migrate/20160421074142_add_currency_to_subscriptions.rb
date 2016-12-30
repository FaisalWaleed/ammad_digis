class AddCurrencyToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :currency, :string, limit: 10
  end
end
