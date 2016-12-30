class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :firstname, limit: 40
      t.string :lastname, limit: 40
      t.string :email, limit: 80
      t.boolean :superadmin, :default => false, :null => false
      t.boolean :active, :default => true, :null => false
      t.string :crypted_password, limit: 255
      t.string :password_salt, limit: 255
      t.string :persistence_token
      t.string :single_access_token, limit: 255
      t.string :perishable_token, limit: 255
      t.integer :login_count
      t.integer :failed_login_count
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip, limit: 40
      t.string :last_login_ip, limit: 40
      t.text :avatar_file_name, limit: 1024
      t.string :avatar_content_type, limit: 255
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at

      t.timestamps null: false
    end
  end
end
