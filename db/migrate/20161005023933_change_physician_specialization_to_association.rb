class ChangePhysicianSpecializationToAssociation < ActiveRecord::Migration
  def up
    remove_column :physicians, :specialization
    add_column :physicians, :specialization_id, :integer
  end

  def down
    remove_column :physicians, :specialization_id
    add_column :physicians, :specialization, :string, :limit => 255
  end
end
