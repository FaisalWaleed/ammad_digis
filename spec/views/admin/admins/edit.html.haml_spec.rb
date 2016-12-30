require 'rails_helper'

RSpec.describe "admin/admins/edit", type: :view do
  before(:each) do
    @admin_admin = assign(:admin_admin, Admin.create!(
      :firstname => "MyString",
      :lastname => "MyString",
      :email => "MyString",
      :superadmin => "MyString",
      :active => "MyString",
      :password => "MyString",
      :password_confirmation => "MyString",
      :avatar => "MyString"
    ))
  end

  it "renders the edit admin_admin form" do
    render

    assert_select "form[action=?][method=?]", admin_admin_path(@admin_admin), "post" do

      assert_select "input#admin_admin_firstname[name=?]", "admin_admin[firstname]"

      assert_select "input#admin_admin_lastname[name=?]", "admin_admin[lastname]"

      assert_select "input#admin_admin_email[name=?]", "admin_admin[email]"

      assert_select "input#admin_admin_superadmin[name=?]", "admin_admin[superadmin]"

      assert_select "input#admin_admin_active[name=?]", "admin_admin[active]"

      assert_select "input#admin_admin_password[name=?]", "admin_admin[password]"

      assert_select "input#admin_admin_password_confirmation[name=?]", "admin_admin[password_confirmation]"

      assert_select "input#admin_admin_avatar[name=?]", "admin_admin[avatar]"
    end
  end
end
