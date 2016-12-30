class AddUniquenessConstraintToDiagnosticsIdentifier < ActiveRecord::Migration
  def change
    add_index :diagnostics, :identifier, unique: true
  end
end
