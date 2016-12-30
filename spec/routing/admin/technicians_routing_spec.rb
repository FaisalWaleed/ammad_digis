require "rails_helper"

RSpec.describe Admin::TechniciansController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/technicians").to route_to("admin/technicians#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/technicians/new").to route_to("admin/technicians#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/technicians/1").to route_to("admin/technicians#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/technicians/1/edit").to route_to("admin/technicians#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/technicians").to route_to("admin/technicians#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/technicians/1").to route_to("admin/technicians#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/technicians/1").to route_to("admin/technicians#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/technicians/1").to route_to("admin/technicians#destroy", :id => "1")
    end

  end
end
