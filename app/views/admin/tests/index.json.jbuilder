json.array!(@tests) do |test|
  json.extract! test, :id, :name, :test_type_id
  json.url test_url(test, format: :json)
end
