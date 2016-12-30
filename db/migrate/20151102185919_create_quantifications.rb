class CreateQuantifications < ActiveRecord::Migration
  def change
    create_table :quantifications do |t|
      t.integer :dosage_unit_id
      t.integer :drug_format_id

      t.timestamps null: false
    end

    add_index :quantifications, [ :dosage_unit_id, :drug_format_id ]
  end
end
