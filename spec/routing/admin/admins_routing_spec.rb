require "rails_helper"

RSpec.describe Admin::AdminsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/admins").to route_to("admin/admins#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/admins/new").to route_to("admin/admins#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/admins/1").to route_to("admin/admins#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/admins/1/edit").to route_to("admin/admins#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/admins").to route_to("admin/admins#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/admins/1").to route_to("admin/admins#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/admins/1").to route_to("admin/admins#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/admins/1").to route_to("admin/admins#destroy", :id => "1")
    end

  end
end
