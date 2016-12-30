require 'rails_helper'

RSpec.describe "Physician::Diagnostics", type: :request do
  describe "GET /physician_diagnostics" do
    it "works! (now write some real specs)" do
      get physician_diagnostics_index_path
      expect(response).to have_http_status(200)
    end
  end
end
