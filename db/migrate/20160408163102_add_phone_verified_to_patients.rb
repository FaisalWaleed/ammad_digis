class AddPhoneVerifiedToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :phone_verified, :boolean, :default => false, :null => false
  end
end
