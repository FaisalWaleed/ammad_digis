require "rails_helper"

RSpec.describe Admin::PharmacistsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/pharmacists").to route_to("admin/pharmacists#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/pharmacists/new").to route_to("admin/pharmacists#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/pharmacists/1").to route_to("admin/pharmacists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/pharmacists/1/edit").to route_to("admin/pharmacists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/pharmacists").to route_to("admin/pharmacists#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/pharmacists/1").to route_to("admin/pharmacists#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/pharmacists/1").to route_to("admin/pharmacists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/pharmacists/1").to route_to("admin/pharmacists#destroy", :id => "1")
    end

  end
end
