class MoveSettlementsFromInvoicesToSubscriptions < ActiveRecord::Migration
  def change
    rename_column :settlements, :invoice_id, :subscription_id
  end
end
