require 'rails_helper'

RSpec.describe "admin/admins/show", type: :view do
  before(:each) do
    @admin_admin = assign(:admin_admin, Admin.create!(
      :firstname => "Firstname",
      :lastname => "Lastname",
      :email => "Email",
      :superadmin => "Superadmin",
      :active => "Active",
      :password => "Password",
      :password_confirmation => "Password Confirmation",
      :avatar => "Avatar"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/Lastname/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Superadmin/)
    expect(rendered).to match(/Active/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/Password Confirmation/)
    expect(rendered).to match(/Avatar/)
  end
end
