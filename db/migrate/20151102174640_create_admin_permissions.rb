class CreateAdminPermissions < ActiveRecord::Migration
  def change
    create_table :admin_permissions do |t|
      t.string :name, limit: 40
      t.text :description, limit: 1024
      t.string :protected_model, limit: 255
      t.integer :admin_role_id
      t.boolean :can_read, :default => true, :null => false
      t.boolean :can_create, :default => false, :null => false
      t.boolean :can_edit, :default => false, :null => false
      t.boolean :can_delete, :default => false, :null => false

      t.timestamps null: false
    end
  end
end
