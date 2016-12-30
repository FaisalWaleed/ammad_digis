require "rails_helper"

RSpec.describe Pharmacist::PharmaciesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/pharmacist/pharmacies").to route_to("pharmacist/pharmacies#index")
    end

    it "routes to #new" do
      expect(:get => "/pharmacist/pharmacies/new").to route_to("pharmacist/pharmacies#new")
    end

    it "routes to #show" do
      expect(:get => "/pharmacist/pharmacies/1").to route_to("pharmacist/pharmacies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pharmacist/pharmacies/1/edit").to route_to("pharmacist/pharmacies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/pharmacist/pharmacies").to route_to("pharmacist/pharmacies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pharmacist/pharmacies/1").to route_to("pharmacist/pharmacies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pharmacist/pharmacies/1").to route_to("pharmacist/pharmacies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pharmacist/pharmacies/1").to route_to("pharmacist/pharmacies#destroy", :id => "1")
    end

  end
end
