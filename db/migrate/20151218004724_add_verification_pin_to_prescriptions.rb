class AddVerificationPinToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :verification_pin, :string, limit: 10
  end
end
