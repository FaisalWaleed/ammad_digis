class AddLast4ToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :merchant_response_card_last4, :string, limit: 4
  end
end
