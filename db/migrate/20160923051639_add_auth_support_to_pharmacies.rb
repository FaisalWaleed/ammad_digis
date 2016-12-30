class AddAuthSupportToPharmacies < ActiveRecord::Migration
  def change
    add_column :pharmacies, :active, :boolean
    add_column :pharmacies, :crypted_password, :string, limit: 255
    add_column :pharmacies, :password_salt, :string, limit: 255
    add_column :pharmacies, :persistence_token, :string, limit: 255
    add_column :pharmacies, :single_access_token, :string, limit: 255
    add_column :pharmacies, :perishable_token, :string, limit: 255
    add_column :pharmacies, :login_count, :integer
    add_column :pharmacies, :failed_login_count, :integer
    add_column :pharmacies, :last_request_at, :datetime
    add_column :pharmacies, :current_login_at, :datetime
    add_column :pharmacies, :last_login_at, :datetime
    add_column :pharmacies, :current_login_ip, :string, limit: 40
    add_column :pharmacies, :last_login_ip, :string, limit: 40
    add_column :pharmacies, :avatar_file_name, :text, limit: 4096
    add_column :pharmacies, :avatar_content_type, :string, limit: 40
    add_column :pharmacies, :avatar_file_size, :integer
    add_column :pharmacies, :avatar_updated_at, :datetime
    add_column :pharmacies, :customer_id, :string, limit: 255
  end
end
