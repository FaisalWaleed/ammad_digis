class AddActiveToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :active, :boolean, :default => false, :null => false
  end
end
