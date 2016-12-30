require "rails_helper"

RSpec.describe Physician::PatientsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/physician/patients").to route_to("physician/patients#index")
    end

    it "routes to #new" do
      expect(:get => "/physician/patients/new").to route_to("physician/patients#new")
    end

    it "routes to #show" do
      expect(:get => "/physician/patients/1").to route_to("physician/patients#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/physician/patients/1/edit").to route_to("physician/patients#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/physician/patients").to route_to("physician/patients#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/physician/patients/1").to route_to("physician/patients#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/physician/patients/1").to route_to("physician/patients#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/physician/patients/1").to route_to("physician/patients#destroy", :id => "1")
    end

  end
end
