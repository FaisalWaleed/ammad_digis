class AddNotesToDiagnostics < ActiveRecord::Migration
  def change
    add_column :diagnostics, :notes, :text, limit: 1024
  end
end
