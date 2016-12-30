json.array!(@test_profiles) do |test_profile|
  json.extract! test_profile, :id, :name, :test_type_id
  json.url test_profile_url(test_profile, format: :json)
end
