require 'rails_helper'

RSpec.describe "Admin::Pharmacists", type: :request do
  describe "GET /admin_pharmacists" do
    it "works! (now write some real specs)" do
      get admin_pharmacists_index_path
      expect(response).to have_http_status(200)
    end
  end
end
