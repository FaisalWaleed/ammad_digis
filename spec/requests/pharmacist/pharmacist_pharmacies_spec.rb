require 'rails_helper'

RSpec.describe "Pharmacist::Pharmacies", type: :request do
  describe "GET /pharmacist_pharmacies" do
    it "works! (now write some real specs)" do
      get pharmacist_pharmacies_index_path
      expect(response).to have_http_status(200)
    end
  end
end
