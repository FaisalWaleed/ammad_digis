class RemoveAllLoginFields < ActiveRecord::Migration
  def change
    remove_column :physicians, :login, :string, limit: 40
    remove_column :pharmacists, :login, :string, limit: 40
    remove_column :technicians, :login, :string, limit: 40
    remove_column :patients, :login, :string, limit: 40
  end
end
