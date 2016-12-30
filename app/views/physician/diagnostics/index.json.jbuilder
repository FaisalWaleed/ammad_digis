json.array!(@diagnostics) do |diagnostic|
  json.extract! diagnostic, :id, :patient_id, :send_to_patient, :laboratory_id
  json.url diagnostic_url(diagnostic, format: :json)
end
