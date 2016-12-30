class AddAttachmentSignatureToPhysicians < ActiveRecord::Migration
  def self.up
    change_table :physicians do |t|
      t.attachment :signature
    end
  end

  def self.down
    remove_attachment :physicians, :signature
  end
end
