class AddIdentifierToDiagnostics < ActiveRecord::Migration
  def change
    add_column :diagnostics, :identifier, :string, limit: 40
  end
end
