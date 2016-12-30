require 'rails_helper'

RSpec.describe "Admin::Admins", type: :request do
  describe "GET /admin_admins" do
    it "works! (now write some real specs)" do
      get admin_admins_index_path
      expect(response).to have_http_status(200)
    end
  end
end
