class AddDefaultToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :default, :boolean, :default => false, :null => false
  end
end
