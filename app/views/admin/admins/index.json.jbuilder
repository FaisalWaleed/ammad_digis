json.array!(@admins) do |admin|
  json.extract! admin, :id, :firstname, :lastname, :email, :superadmin, :active, :password, :password_confirmation, :avatar
  json.url admin_url(admin, format: :json)
end
