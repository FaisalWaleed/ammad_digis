require 'rails_helper'

RSpec.describe "Admin::Pharmacies", type: :request do
  describe "GET /admin_pharmacies" do
    it "works! (now write some real specs)" do
      get admin_pharmacies_index_path
      expect(response).to have_http_status(200)
    end
  end
end
