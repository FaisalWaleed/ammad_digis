class MoveTestResultsFromTestingsToDiagnostics < ActiveRecord::Migration
  def change
    rename_column :test_results, :test_id, :diagnostic_id
  end
end
