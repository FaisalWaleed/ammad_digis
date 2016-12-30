class AddNotificationMethodsToPhysicians < ActiveRecord::Migration
  def change
    add_column :physicians, :notify_via_email, :boolean, :default => true, :null => false
    add_column :physicians, :notify_via_sms, :boolean, :default => true, :null => false
  end
end
