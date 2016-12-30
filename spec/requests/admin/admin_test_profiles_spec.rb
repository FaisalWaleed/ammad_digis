require 'rails_helper'

RSpec.describe "Admin::TestProfiles", type: :request do
  describe "GET /admin_test_profiles" do
    it "works! (now write some real specs)" do
      get admin_test_profiles_index_path
      expect(response).to have_http_status(200)
    end
  end
end
