require 'rails_helper'

RSpec.describe "admin/admins/index", type: :view do
  before(:each) do
    assign(:admins, [
      Admin.create!(
        :firstname => "Firstname",
        :lastname => "Lastname",
        :email => "Email",
        :superadmin => "Superadmin",
        :active => "Active",
        :password => "Password",
        :password_confirmation => "Password Confirmation",
        :avatar => "Avatar"
      ),
      Admin.create!(
        :firstname => "Firstname",
        :lastname => "Lastname",
        :email => "Email",
        :superadmin => "Superadmin",
        :active => "Active",
        :password => "Password",
        :password_confirmation => "Password Confirmation",
        :avatar => "Avatar"
      )
    ])
  end

  it "renders a list of admin/admins" do
    render
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Superadmin".to_s, :count => 2
    assert_select "tr>td", :text => "Active".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => "Password Confirmation".to_s, :count => 2
    assert_select "tr>td", :text => "Avatar".to_s, :count => 2
  end
end
