require "rails_helper"

RSpec.describe Admin::DrugsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/drugs").to route_to("admin/drugs#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/drugs/new").to route_to("admin/drugs#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/drugs/1").to route_to("admin/drugs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/drugs/1/edit").to route_to("admin/drugs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/drugs").to route_to("admin/drugs#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/drugs/1").to route_to("admin/drugs#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/drugs/1").to route_to("admin/drugs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/drugs/1").to route_to("admin/drugs#destroy", :id => "1")
    end

  end
end
