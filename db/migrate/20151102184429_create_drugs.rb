class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.string :trade_name, limit: 40
      t.string :generic_name, limit: 40
      t.integer :drug_format_id
      t.string :dosages, limit: 40

      t.timestamps null: false
    end

    add_index :drugs, :trade_name
    add_index :drugs, :generic_name
  end
end
