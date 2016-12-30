require 'rails_helper'

RSpec.describe "admin/drugs/show", type: :view do
  before(:each) do
    @admin_drug = assign(:admin_drug, Drug.create!(
      :trade_name => "Trade Name",
      :generic_name => "Generic Name",
      :drug_format_id => "Drug Format",
      :dosages => "Dosages"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Trade Name/)
    expect(rendered).to match(/Generic Name/)
    expect(rendered).to match(/Drug Format/)
    expect(rendered).to match(/Dosages/)
  end
end
