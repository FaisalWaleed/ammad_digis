class CreateAdminRoleAssignments < ActiveRecord::Migration
  def change
    create_table :admin_role_assignments do |t|
      t.integer :admin_role_id
      t.integer :admin_id

      t.timestamps null: false
    end

    add_index :admin_role_assignments, [ :admin_role_id, :admin_id ]
  end
end
