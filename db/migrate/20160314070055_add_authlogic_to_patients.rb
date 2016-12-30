class AddAuthlogicToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :login, :string, limit: 40
    add_column :patients, :active, :boolean, :default => true, :null => false
    add_column :patients, :crypted_password, :string, limit: 255
    add_column :patients, :password_salt, :string, limit: 255
    add_column :patients, :persistence_token, :string
    add_column :patients, :single_access_token, :string, limit: 255
    add_column :patients, :perishable_token, :string, limit: 255
    add_column :patients, :login_count, :integer
    add_column :patients, :failed_login_count, :integer
    add_column :patients, :last_request_at, :datetime
    add_column :patients, :current_login_at, :datetime
    add_column :patients, :last_login_at, :datetime
    add_column :patients, :current_login_ip, :string, limit: 40
    add_column :patients, :last_login_ip, :string, limit: 40
  end
end
