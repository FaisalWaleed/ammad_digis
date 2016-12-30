class MakeUsdDefaultCurrencyForPlans < ActiveRecord::Migration
  def change
    change_column :plans, :currency, :string, :default => 'usd', :null => false
  end
end
