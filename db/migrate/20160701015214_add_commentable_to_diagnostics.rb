class AddCommentableToDiagnostics < ActiveRecord::Migration
  def change
    add_column :diagnostics, :commentable, :boolean, :default => true, :null => false
  end
end
