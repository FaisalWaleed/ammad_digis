class AddRequireResponseToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :require_response, :boolean, :default => true, :null => false
  end
end
