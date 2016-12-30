class AddVerificationCodesToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :email_verification_code, :string, limit: 10
    add_column :patients, :phone_verification_code, :string, limit: 10
  end
end
