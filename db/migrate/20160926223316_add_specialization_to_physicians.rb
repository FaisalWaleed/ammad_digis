class AddSpecializationToPhysicians < ActiveRecord::Migration
  def change
    add_column :physicians, :specialization, :string, limit: 255
  end
end
