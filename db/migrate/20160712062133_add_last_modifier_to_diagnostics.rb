class AddLastModifierToDiagnostics < ActiveRecord::Migration
  def change
    add_column :diagnostics, :last_modifier_type, :string, limit: 40
    add_column :diagnostics, :last_modifier_id, :integer
  end
end
