class AddAuthSupportToLaboratories < ActiveRecord::Migration
  def change
    add_column :laboratories, :active, :boolean
    add_column :laboratories, :crypted_password, :string, limit: 255
    add_column :laboratories, :password_salt, :string, limit: 255
    add_column :laboratories, :persistence_token, :string, limit: 255
    add_column :laboratories, :single_access_token, :string, limit: 255
    add_column :laboratories, :perishable_token, :string, limit: 255
    add_column :laboratories, :login_count, :integer
    add_column :laboratories, :failed_login_count, :integer
    add_column :laboratories, :last_request_at, :datetime
    add_column :laboratories, :current_login_at, :datetime
    add_column :laboratories, :last_login_at, :datetime
    add_column :laboratories, :current_login_ip, :string, limit: 40
    add_column :laboratories, :last_login_ip, :string, limit: 40
    add_column :laboratories, :avatar_file_name, :text, limit: 4096
    add_column :laboratories, :avatar_content_type, :string, limit: 40
    add_column :laboratories, :avatar_file_size, :integer
    add_column :laboratories, :avatar_updated_at, :datetime
    add_column :laboratories, :customer_id, :string, limit: 255
  end
end
