require 'rails_helper'

RSpec.describe "admin/drugs/edit", type: :view do
  before(:each) do
    @admin_drug = assign(:admin_drug, Drug.create!(
      :trade_name => "MyString",
      :generic_name => "MyString",
      :drug_format_id => "MyString",
      :dosages => "MyString"
    ))
  end

  it "renders the edit admin_drug form" do
    render

    assert_select "form[action=?][method=?]", admin_drug_path(@admin_drug), "post" do

      assert_select "input#admin_drug_trade_name[name=?]", "admin_drug[trade_name]"

      assert_select "input#admin_drug_generic_name[name=?]", "admin_drug[generic_name]"

      assert_select "input#admin_drug_drug_format_id[name=?]", "admin_drug[drug_format_id]"

      assert_select "input#admin_drug_dosages[name=?]", "admin_drug[dosages]"
    end
  end
end
