class AddTitleToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :title, :string, limit: 255
  end
end
