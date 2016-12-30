require "rails_helper"

RSpec.describe Admin::TestsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/tests").to route_to("admin/tests#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/tests/new").to route_to("admin/tests#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/tests/1").to route_to("admin/tests#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/tests/1/edit").to route_to("admin/tests#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/tests").to route_to("admin/tests#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/tests/1").to route_to("admin/tests#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/tests/1").to route_to("admin/tests#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/tests/1").to route_to("admin/tests#destroy", :id => "1")
    end

  end
end
