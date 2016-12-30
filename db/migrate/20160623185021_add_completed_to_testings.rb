class AddCompletedToTestings < ActiveRecord::Migration
  def change
    add_column :testings, :completed, :boolean, :default => false, :null => false
  end
end
