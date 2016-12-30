class AddLimitsToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :subscriber_limit, :integer, :default => 0, :null => false
    add_column :plans, :organization_limit, :integer, :default => 0, :null => false
  end
end
