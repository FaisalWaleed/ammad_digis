require 'rails_helper'

RSpec.describe "Admin::Drugs", type: :request do
  describe "GET /admin_drugs" do
    it "works! (now write some real specs)" do
      get admin_drugs_index_path
      expect(response).to have_http_status(200)
    end
  end
end
