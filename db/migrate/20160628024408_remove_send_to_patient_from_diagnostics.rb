class RemoveSendToPatientFromDiagnostics < ActiveRecord::Migration
  def change
    remove_column :diagnostics, :send_to_patient, :boolean, :default => false, :null => false
  end
end
