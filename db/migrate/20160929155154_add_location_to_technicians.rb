class AddLocationToTechnicians < ActiveRecord::Migration
  def change
    add_column :technicians, :location_id, :integer
  end
end
