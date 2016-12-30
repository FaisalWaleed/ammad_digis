require "rails_helper"

RSpec.describe Admin::PatientsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/patients").to route_to("admin/patients#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/patients/new").to route_to("admin/patients#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/patients/1").to route_to("admin/patients#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/patients/1/edit").to route_to("admin/patients#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/patients").to route_to("admin/patients#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/patients/1").to route_to("admin/patients#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/patients/1").to route_to("admin/patients#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/patients/1").to route_to("admin/patients#destroy", :id => "1")
    end

  end
end
