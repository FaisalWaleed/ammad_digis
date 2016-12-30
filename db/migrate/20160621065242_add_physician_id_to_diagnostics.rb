class AddPhysicianIdToDiagnostics < ActiveRecord::Migration
  def change
    add_column :diagnostics, :physician_id, :integer
  end
end
