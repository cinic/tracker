require 'rails_helper'

RSpec.describe "Admin::Dashboards", :type => :request do
  describe "GET /admin_dashboards" do
    it "works! (now write some real specs)" do
      get admin_dashboards_path
      expect(response.status).to be(200)
    end
  end
end
