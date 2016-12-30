require 'rails_helper'

RSpec.describe "admin/drugs/index", type: :view do
  before(:each) do
    assign(:drugs, [
      Drug.create!(
        :trade_name => "Trade Name",
        :generic_name => "Generic Name",
        :drug_format_id => "Drug Format",
        :dosages => "Dosages"
      ),
      Drug.create!(
        :trade_name => "Trade Name",
        :generic_name => "Generic Name",
        :drug_format_id => "Drug Format",
        :dosages => "Dosages"
      )
    ])
  end

  it "renders a list of admin/drugs" do
    render
    assert_select "tr>td", :text => "Trade Name".to_s, :count => 2
    assert_select "tr>td", :text => "Generic Name".to_s, :count => 2
    assert_select "tr>td", :text => "Drug Format".to_s, :count => 2
    assert_select "tr>td", :text => "Dosages".to_s, :count => 2
  end
end
