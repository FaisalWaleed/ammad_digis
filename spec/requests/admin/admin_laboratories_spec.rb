require 'rails_helper'

RSpec.describe "Admin::Laboratories", type: :request do
  describe "GET /admin_laboratories" do
    it "works! (now write some real specs)" do
      get admin_laboratories_index_path
      expect(response).to have_http_status(200)
    end
  end
end
