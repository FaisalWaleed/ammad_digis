class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :attachable_type, limit: 40
      t.integer :attachable_id

      t.timestamps null: false
    end
  end
end
