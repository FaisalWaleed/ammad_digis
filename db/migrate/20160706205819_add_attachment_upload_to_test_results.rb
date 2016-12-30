class AddAttachmentUploadToTestResults < ActiveRecord::Migration
  def self.up
    change_table :test_results do |t|
      t.attachment :upload
    end
  end

  def self.down
    remove_attachment :test_results, :upload
  end
end
