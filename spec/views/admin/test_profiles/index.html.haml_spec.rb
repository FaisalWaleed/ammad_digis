require 'rails_helper'

RSpec.describe "admin/test_profiles/index", type: :view do
  before(:each) do
    assign(:test_profiles, [
      TestProfile.create!(
        :name => "Name",
        :test_type_id => "Test Type"
      ),
      TestProfile.create!(
        :name => "Name",
        :test_type_id => "Test Type"
      )
    ])
  end

  it "renders a list of admin/test_profiles" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Test Type".to_s, :count => 2
  end
end
