require 'rails_helper'

RSpec.describe "pharmacist/pharmacists/show", type: :view do
  before(:each) do
    @pharmacist_pharmacist = assign(:pharmacist_pharmacist, Pharmacist.create!(
      :firstname => "Firstname",
      :lastname => "Lastname",
      :middlename => "Middlename",
      :gender_id => "Gender",
      :date_of_birth => "Date Of Birth",
      :address_street_1 => "Address Street 1",
      :address_street_2 => "Address Street 2",
      :address_municipality => "Address Municipality",
      :address_territory => "Address Territory",
      :address_postal_code => "Address Postal Code",
      :address_country => "Address Country",
      :email_primary => "Email Primary",
      :phone_primary => "Phone Primary",
      :reg_num => "Reg Num",
      :avatar => "Avatar",
      :password => "Password",
      :password_confirmation => "Password Confirmation"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/Lastname/)
    expect(rendered).to match(/Middlename/)
    expect(rendered).to match(/Gender/)
    expect(rendered).to match(/Date Of Birth/)
    expect(rendered).to match(/Address Street 1/)
    expect(rendered).to match(/Address Street 2/)
    expect(rendered).to match(/Address Municipality/)
    expect(rendered).to match(/Address Territory/)
    expect(rendered).to match(/Address Postal Code/)
    expect(rendered).to match(/Address Country/)
    expect(rendered).to match(/Email Primary/)
    expect(rendered).to match(/Phone Primary/)
    expect(rendered).to match(/Reg Num/)
    expect(rendered).to match(/Avatar/)
    expect(rendered).to match(/Password/)
    expect(rendered).to match(/Password Confirmation/)
  end
end
