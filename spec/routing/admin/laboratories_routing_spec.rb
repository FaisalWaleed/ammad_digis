require "rails_helper"

RSpec.describe Admin::LaboratoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/laboratories").to route_to("admin/laboratories#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/laboratories/new").to route_to("admin/laboratories#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/laboratories/1").to route_to("admin/laboratories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/laboratories/1/edit").to route_to("admin/laboratories#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/laboratories").to route_to("admin/laboratories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/laboratories/1").to route_to("admin/laboratories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/laboratories/1").to route_to("admin/laboratories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/laboratories/1").to route_to("admin/laboratories#destroy", :id => "1")
    end

  end
end
