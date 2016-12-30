require 'rails_helper'

RSpec.describe "admin/tests/edit", type: :view do
  before(:each) do
    @admin_test = assign(:admin_test, Test.create!(
      :name => "MyString",
      :test_type_id => "MyString"
    ))
  end

  it "renders the edit admin_test form" do
    render

    assert_select "form[action=?][method=?]", admin_test_path(@admin_test), "post" do

      assert_select "input#admin_test_name[name=?]", "admin_test[name]"

      assert_select "input#admin_test_test_type_id[name=?]", "admin_test[test_type_id]"
    end
  end
end
