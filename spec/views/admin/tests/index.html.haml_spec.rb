require 'rails_helper'

RSpec.describe "admin/tests/index", type: :view do
  before(:each) do
    assign(:tests, [
      Test.create!(
        :name => "Name",
        :test_type_id => "Test Type"
      ),
      Test.create!(
        :name => "Name",
        :test_type_id => "Test Type"
      )
    ])
  end

  it "renders a list of admin/tests" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Test Type".to_s, :count => 2
  end
end
