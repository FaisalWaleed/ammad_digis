require "rails_helper"

RSpec.describe Pharmacist::PharmacistsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/pharmacist/pharmacists").to route_to("pharmacist/pharmacists#index")
    end

    it "routes to #new" do
      expect(:get => "/pharmacist/pharmacists/new").to route_to("pharmacist/pharmacists#new")
    end

    it "routes to #show" do
      expect(:get => "/pharmacist/pharmacists/1").to route_to("pharmacist/pharmacists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pharmacist/pharmacists/1/edit").to route_to("pharmacist/pharmacists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/pharmacist/pharmacists").to route_to("pharmacist/pharmacists#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pharmacist/pharmacists/1").to route_to("pharmacist/pharmacists#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pharmacist/pharmacists/1").to route_to("pharmacist/pharmacists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pharmacist/pharmacists/1").to route_to("pharmacist/pharmacists#destroy", :id => "1")
    end

  end
end
