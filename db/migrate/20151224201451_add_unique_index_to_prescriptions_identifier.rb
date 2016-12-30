class AddUniqueIndexToPrescriptionsIdentifier < ActiveRecord::Migration
  def change
    add_index :prescriptions, [:identifier], :unique => true
  end
end
