class AddNoteToPrescripts < ActiveRecord::Migration
  def change
    add_column :prescripts, :note, :text, limit: 1024
  end
end
