class AddDescriptionToDosageRoutes < ActiveRecord::Migration
  def change
    add_column :dosage_routes, :description, :string, limit: 255
  end
end
