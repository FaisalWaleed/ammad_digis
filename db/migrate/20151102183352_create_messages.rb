class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject, limit: 255
      t.text :body, limit: 4096
      t.integer :sender_id
      t.string :sender_type, limit: 20
      t.integer :asset_id
      t.string :asset_type, limit: 20
      t.boolean :read, :default => false, :null => false
      t.boolean :urgent, :default => false, :null => false

      t.timestamps null: false
    end
  end
end
