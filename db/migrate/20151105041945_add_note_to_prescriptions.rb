class AddNoteToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :note, :text, limit: 1024
  end
end
