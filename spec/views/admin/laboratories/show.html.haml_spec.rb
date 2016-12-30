require 'rails_helper'

RSpec.describe "admin/laboratories/show", type: :view do
  before(:each) do
    @admin_laboratory = assign(:admin_laboratory, Laboratory.create!(
      :name => "Name",
      :contact_firstname => "Contact Firstname",
      :contact_lastname => "Contact Lastname",
      :address_street_1 => "Address Street 1",
      :address_street_2 => "Address Street 2",
      :address_municipality => "Address Municipality",
      :address_territory => "Address Territory",
      :address_postal_code => "Address Postal Code",
      :address_country => "Address Country",
      :latitude => "Latitude",
      :longitude => "Longitude",
      :email_primary => "Email Primary",
      :email_secondary => "Email Secondary",
      :phone_primary => "Phone Primary",
      :phone_secondary => "Phone Secondary",
      :phone_mobile => "Phone Mobile",
      :phone_alternate => "Phone Alternate",
      :reg_num => "Reg Num"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Contact Firstname/)
    expect(rendered).to match(/Contact Lastname/)
    expect(rendered).to match(/Address Street 1/)
    expect(rendered).to match(/Address Street 2/)
    expect(rendered).to match(/Address Municipality/)
    expect(rendered).to match(/Address Territory/)
    expect(rendered).to match(/Address Postal Code/)
    expect(rendered).to match(/Address Country/)
    expect(rendered).to match(/Latitude/)
    expect(rendered).to match(/Longitude/)
    expect(rendered).to match(/Email Primary/)
    expect(rendered).to match(/Email Secondary/)
    expect(rendered).to match(/Phone Primary/)
    expect(rendered).to match(/Phone Secondary/)
    expect(rendered).to match(/Phone Mobile/)
    expect(rendered).to match(/Phone Alternate/)
    expect(rendered).to match(/Reg Num/)
  end
end
