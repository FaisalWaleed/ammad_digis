class AddPlanPublishIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :plan_publish_id, :string, limit: 255
  end
end
