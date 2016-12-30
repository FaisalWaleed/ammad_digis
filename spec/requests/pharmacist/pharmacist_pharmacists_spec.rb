require 'rails_helper'

RSpec.describe "Pharmacist::Pharmacists", type: :request do
  describe "GET /pharmacist_pharmacists" do
    it "works! (now write some real specs)" do
      get pharmacist_pharmacists_index_path
      expect(response).to have_http_status(200)
    end
  end
end
