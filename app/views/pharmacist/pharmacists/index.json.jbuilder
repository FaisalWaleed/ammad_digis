json.array!(@pharmacists) do |pharmacist|
  json.extract! pharmacist, :id, :firstname, :lastname, :middlename, :gender_id, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :phone_primary, :reg_num, :avatar, :password, :password_confirmation
  json.url pharmacist_pharmacist_url(pharmacist, format: :json)
end
