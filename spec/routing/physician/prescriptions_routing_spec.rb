require "rails_helper"

RSpec.describe Physician::PrescriptionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/physician/prescriptions").to route_to("physician/prescriptions#index")
    end

    it "routes to #new" do
      expect(:get => "/physician/prescriptions/new").to route_to("physician/prescriptions#new")
    end

    it "routes to #show" do
      expect(:get => "/physician/prescriptions/1").to route_to("physician/prescriptions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/physician/prescriptions/1/edit").to route_to("physician/prescriptions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/physician/prescriptions").to route_to("physician/prescriptions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/physician/prescriptions/1").to route_to("physician/prescriptions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/physician/prescriptions/1").to route_to("physician/prescriptions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/physician/prescriptions/1").to route_to("physician/prescriptions#destroy", :id => "1")
    end

  end
end
