class AddPublishingToDiagnostics < ActiveRecord::Migration
  def change
    add_column :diagnostics, :archived_for_physician, :boolean, :default => false, :null => false
    add_column :diagnostics, :archived_for_technician, :boolean, :default => false, :null => false
  end
end
