class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :firstname, limit: 40
      t.string :lastname, limit: 40
      t.string :middlename, limit: 40
      t.integer :gender_id
      t.date :date_of_birth
      t.text :general_notes, limit: 4096
      t.text :hx_notes, limit: 4096
      t.text :surgical_history, limit: 4096
      t.integer :physician_id
      t.string :address_street_1, limit: 255
      t.string :address_street_2, limit: 255
      t.string :address_municipality, limit: 80
      t.string :address_territory, limit: 80
      t.string :address_postal_code, limit: 10
      t.string :address_country, limit: 40
      t.string :email_primary, limit: 80
      t.string :email_secondary, limit: 80
      t.string :phone_primary, limit: 40
      t.string :phone_secondary, limit: 40
      t.string :phone_mobile, limit: 40
      t.string :phone_alternate, limit: 40
      t.integer :personal_id_type_id
      t.string :personal_id_code, limit: 80
      t.text :avatar_file_name, limit: 1024
      t.string :avatar_content_type, limit: 255
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at

      t.timestamps null: false
    end

    add_index :patients, :firstname
    add_index :patients, :lastname
  end
end
