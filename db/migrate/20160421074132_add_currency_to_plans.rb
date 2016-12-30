class AddCurrencyToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :currency, :string, limit: 10
  end
end
