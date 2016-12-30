require "rails_helper"

RSpec.describe Physician::DiagnosticsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/physician/diagnostics").to route_to("physician/diagnostics#index")
    end

    it "routes to #new" do
      expect(:get => "/physician/diagnostics/new").to route_to("physician/diagnostics#new")
    end

    it "routes to #show" do
      expect(:get => "/physician/diagnostics/1").to route_to("physician/diagnostics#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/physician/diagnostics/1/edit").to route_to("physician/diagnostics#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/physician/diagnostics").to route_to("physician/diagnostics#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/physician/diagnostics/1").to route_to("physician/diagnostics#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/physician/diagnostics/1").to route_to("physician/diagnostics#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/physician/diagnostics/1").to route_to("physician/diagnostics#destroy", :id => "1")
    end

  end
end
