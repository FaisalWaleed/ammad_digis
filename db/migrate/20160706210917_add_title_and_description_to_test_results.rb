class AddTitleAndDescriptionToTestResults < ActiveRecord::Migration
  def change
    add_column :test_results, :title, :string, limit: 255
    add_column :test_results, :description, :text, limit: 2048
  end
end
