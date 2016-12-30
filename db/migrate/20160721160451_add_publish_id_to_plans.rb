class AddPublishIdToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :publish_id, :string, limit: 255
  end
end
