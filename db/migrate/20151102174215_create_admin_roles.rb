class CreateAdminRoles < ActiveRecord::Migration
  def change
    create_table :admin_roles do |t|
      t.string :name, limit: 40

      t.timestamps null: false
    end
  end
end
