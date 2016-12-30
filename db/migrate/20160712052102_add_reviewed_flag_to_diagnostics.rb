class AddReviewedFlagToDiagnostics < ActiveRecord::Migration
  def change
    add_column :diagnostics, :reviewed, :boolean, :default => false, :null => false
  end
end
