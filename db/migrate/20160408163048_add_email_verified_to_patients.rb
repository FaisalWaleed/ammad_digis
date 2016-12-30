class AddEmailVerifiedToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :email_verified, :boolean, :default => false, :null => false
  end
end
