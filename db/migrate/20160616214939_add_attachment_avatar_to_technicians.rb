class AddAttachmentAvatarToTechnicians < ActiveRecord::Migration
  def self.up
    change_table :technicians do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :technicians, :avatar
  end
end
