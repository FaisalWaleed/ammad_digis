class AddViewedFlagToTestResults < ActiveRecord::Migration
  def change
    add_column :test_results, :viewed, :boolean, :default => false, :null => false
  end
end
