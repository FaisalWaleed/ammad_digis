json.array!(@prescriptions) do |prescription|
  json.extract! prescription, :id, :identifier, :patient_id
  json.url prescription_url(prescription, format: :json)
end
