require 'rails_helper'

RSpec.describe "admin/technicians/index", type: :view do
  before(:each) do
    assign(:technicians, [
      Technician.create!(
        :firstname => "Firstname",
        :middlename => "Middlename",
        :lastname => "Lastname",
        :gender_id => "Gender",
        :date_of_birth => "Date Of Birth",
        :address_street_1 => "Address Street 1",
        :address_street_2 => "Address Street 2",
        :address_municipality => "Address Municipality",
        :address_territory => "Address Territory",
        :address_postal_code => "Address Postal Code",
        :address_country => "Address Country",
        :email_primary => "Email Primary",
        :email_secondary => "Email Secondary",
        :phone_primary => "Phone Primary",
        :phone_secondary => "Phone Secondary",
        :phone_mobile => "Phone Mobile",
        :phone_alternate => "Phone Alternate",
        :reg_num => "Reg Num",
        :active => "Active",
        :admin => "Admin",
        :avatar => "Avatar",
        :password => "Password",
        :password_confirmation => "Password Confirmation",
        :login => "Login"
      ),
      Technician.create!(
        :firstname => "Firstname",
        :middlename => "Middlename",
        :lastname => "Lastname",
        :gender_id => "Gender",
        :date_of_birth => "Date Of Birth",
        :address_street_1 => "Address Street 1",
        :address_street_2 => "Address Street 2",
        :address_municipality => "Address Municipality",
        :address_territory => "Address Territory",
        :address_postal_code => "Address Postal Code",
        :address_country => "Address Country",
        :email_primary => "Email Primary",
        :email_secondary => "Email Secondary",
        :phone_primary => "Phone Primary",
        :phone_secondary => "Phone Secondary",
        :phone_mobile => "Phone Mobile",
        :phone_alternate => "Phone Alternate",
        :reg_num => "Reg Num",
        :active => "Active",
        :admin => "Admin",
        :avatar => "Avatar",
        :password => "Password",
        :password_confirmation => "Password Confirmation",
        :login => "Login"
      )
    ])
  end

  it "renders a list of admin/technicians" do
    render
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Middlename".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => "Date Of Birth".to_s, :count => 2
    assert_select "tr>td", :text => "Address Street 1".to_s, :count => 2
    assert_select "tr>td", :text => "Address Street 2".to_s, :count => 2
    assert_select "tr>td", :text => "Address Municipality".to_s, :count => 2
    assert_select "tr>td", :text => "Address Territory".to_s, :count => 2
    assert_select "tr>td", :text => "Address Postal Code".to_s, :count => 2
    assert_select "tr>td", :text => "Address Country".to_s, :count => 2
    assert_select "tr>td", :text => "Email Primary".to_s, :count => 2
    assert_select "tr>td", :text => "Email Secondary".to_s, :count => 2
    assert_select "tr>td", :text => "Phone Primary".to_s, :count => 2
    assert_select "tr>td", :text => "Phone Secondary".to_s, :count => 2
    assert_select "tr>td", :text => "Phone Mobile".to_s, :count => 2
    assert_select "tr>td", :text => "Phone Alternate".to_s, :count => 2
    assert_select "tr>td", :text => "Reg Num".to_s, :count => 2
    assert_select "tr>td", :text => "Active".to_s, :count => 2
    assert_select "tr>td", :text => "Admin".to_s, :count => 2
    assert_select "tr>td", :text => "Avatar".to_s, :count => 2
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => "Password Confirmation".to_s, :count => 2
    assert_select "tr>td", :text => "Login".to_s, :count => 2
  end
end
