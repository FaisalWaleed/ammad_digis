require 'rails_helper'

RSpec.describe "admin/physicians/show", type: :view do
  before(:each) do
    @admin_physician = assign(:admin_physician, Physician.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/Middlename/)
    expect(rendered).to match(/Lastname/)
    expect(rendered).to match(/Gender/)
    expect(rendered).to match(/Date Of Birth/)
    expect(rendered).to match(/Address Street 1/)
    expect(rendered).to match(/Address Street 2/)
    expect(rendered).to match(/Address Municipality/)
    expect(rendered).to match(/Address Territory/)
    expect(rendered).to match(/Address Postal Code/)
    expect(rendered).to match(/Address Country/)
    expect(rendered).to match(/Email Primary/)
    expect(rendered).to match(/Email Secondary/)
    expect(rendered).to match(/Phone Primary/)
    expect(rendered).to match(/Phone Secondary/)
    expect(rendered).to match(/Phone Mobile/)
    expect(rendered).to match(/Phone Alternate/)
    expect(rendered).to match(/Reg Num/)
    expect(rendered).to match(/Active/)
    expect(rendered).to match(/Avatar/)
  end
end
