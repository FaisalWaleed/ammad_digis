require "rails_helper"

RSpec.describe Admin::TestProfilesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/test_profiles").to route_to("admin/test_profiles#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/test_profiles/new").to route_to("admin/test_profiles#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/test_profiles/1").to route_to("admin/test_profiles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/test_profiles/1/edit").to route_to("admin/test_profiles#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/test_profiles").to route_to("admin/test_profiles#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/test_profiles/1").to route_to("admin/test_profiles#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/test_profiles/1").to route_to("admin/test_profiles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/test_profiles/1").to route_to("admin/test_profiles#destroy", :id => "1")
    end

  end
end
