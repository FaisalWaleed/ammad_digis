json.array!(@physicians) do |physician|
  json.extract! physician, :id, :firstname, :middlename, :lastname, :gender_id, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :phone_mobile, :phone_alternate, :reg_num, :active, :avatar
  json.url physician_url(physician, format: :json)
end
