json.array!(@drugs) do |drug|
  json.extract! drug, :id, :trade_name, :generic_name, :drug_format_id, :dosages
  json.url drug_url(drug, format: :json)
end
