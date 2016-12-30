class AddLimitsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :subscriber_limit, :integer, :default => 0, :null => false
    add_column :subscriptions, :organization_limit, :integer, :default => 0, :null => false
  end
end
