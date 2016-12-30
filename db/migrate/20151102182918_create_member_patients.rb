class CreateMemberPatients < ActiveRecord::Migration
  def change
    create_table :member_patients do |t|
      t.string :login, limit: 40
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

      t.timestamps null: false
    end
  end
end
