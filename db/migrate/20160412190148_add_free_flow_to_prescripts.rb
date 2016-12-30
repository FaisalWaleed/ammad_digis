class AddFreeFlowToPrescripts < ActiveRecord::Migration
  def change
    add_column :prescripts, :free_flow, :boolean, :default => false, :null => false
    add_column :prescripts, :free_flow_details, :text, limit: 1024
  end
end
