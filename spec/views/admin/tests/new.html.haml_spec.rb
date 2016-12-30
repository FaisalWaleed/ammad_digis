require 'rails_helper'

RSpec.describe "admin/tests/new", type: :view do
  before(:each) do
    assign(:admin_test, Test.new(
      :name => "MyString",
      :test_type_id => "MyString"
    ))
  end

  it "renders new admin_test form" do
    render

    assert_select "form[action=?][method=?]", tests_path, "post" do

      assert_select "input#admin_test_name[name=?]", "admin_test[name]"

      assert_select "input#admin_test_test_type_id[name=?]", "admin_test[test_type_id]"
    end
  end
end
