require "rails_helper"

RSpec.describe Admin::PhysiciansController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/physicians").to route_to("admin/physicians#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/physicians/new").to route_to("admin/physicians#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/physicians/1").to route_to("admin/physicians#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/physicians/1/edit").to route_to("admin/physicians#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/physicians").to route_to("admin/physicians#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/physicians/1").to route_to("admin/physicians#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/physicians/1").to route_to("admin/physicians#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/physicians/1").to route_to("admin/physicians#destroy", :id => "1")
    end

  end
end
