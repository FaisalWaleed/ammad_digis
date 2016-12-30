require 'rails_helper'

RSpec.describe "admin/physicians/index", type: :view do
  before(:each) do
    assign(:physicians, [
      Physician.create!(
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
        :avatar => "Avatar"
      ),
      Physician.create!(
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
        :avatar => "Avatar"
      )
    ])
  end

  it "renders a list of admin/physicians" do
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
    assert_select "tr>td", :text => "Avatar".to_s, :count => 2
  end
end
