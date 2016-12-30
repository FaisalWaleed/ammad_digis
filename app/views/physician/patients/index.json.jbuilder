json.array!(@patients) do |patient|
  json.extract! patient, :id, :firstname, :lastname, :middlename, :date_of_birth, :address_street_1, :address_street_2, :address_municipality, :address_territory, :address_postal_code, :address_country, :email_primary, :email_secondary, :phone_primary, :phone_secondary, :phone_mobile, :phone_alternate
  
  json.url physician_patient_url(patient)
  
  json.avatars( patient.avatar_urls )
  
  json.gender(patient.gender.name)
  
  json.name(patient.name)
end
