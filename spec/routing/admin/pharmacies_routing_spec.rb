require "rails_helper"

RSpec.describe Admin::PharmaciesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/pharmacies").to route_to("admin/pharmacies#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/pharmacies/new").to route_to("admin/pharmacies#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/pharmacies/1").to route_to("admin/pharmacies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/pharmacies/1/edit").to route_to("admin/pharmacies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/pharmacies").to route_to("admin/pharmacies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/pharmacies/1").to route_to("admin/pharmacies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/pharmacies/1").to route_to("admin/pharmacies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/pharmacies/1").to route_to("admin/pharmacies#destroy", :id => "1")
    end

  end
end
