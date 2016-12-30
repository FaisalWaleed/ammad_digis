require 'rails_helper'

RSpec.describe "Physician::Patients", type: :request do
  describe "GET /physician_patients" do
    it "works! (now write some real specs)" do
      get physician_patients_index_path
      expect(response).to have_http_status(200)
    end
  end
end
