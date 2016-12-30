class WidenNameColumnOnTests < ActiveRecord::Migration
  def up
    change_column :tests, :name, :string, :limit => 255
  end

  def down
    change_column :tests, :name, :string, :limit => 40
  end
end
