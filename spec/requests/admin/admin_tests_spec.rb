require 'rails_helper'

RSpec.describe "Admin::Tests", type: :request do
  describe "GET /admin_tests" do
    it "works! (now write some real specs)" do
      get admin_tests_index_path
      expect(response).to have_http_status(200)
    end
  end
end
