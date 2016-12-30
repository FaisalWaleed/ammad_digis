require 'rails_helper'

RSpec.describe "Physician::Prescriptions", type: :request do
  describe "GET /physician_prescriptions" do
    it "works! (now write some real specs)" do
      get physician_prescriptions_index_path
      expect(response).to have_http_status(200)
    end
  end
end
