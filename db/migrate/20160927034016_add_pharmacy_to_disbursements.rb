class AddPharmacyToDisbursements < ActiveRecord::Migration
  def change
    add_column :disbursements, :pharmacy_id, :integer
  end
end
