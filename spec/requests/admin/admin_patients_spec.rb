require 'rails_helper'

RSpec.describe "Admin::Patients", type: :request do
  describe "GET /admin_patients" do
    it "works! (now write some real specs)" do
      get admin_patients_index_path
      expect(response).to have_http_status(200)
    end
  end
end
