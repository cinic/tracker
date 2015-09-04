require 'rails_helper'

RSpec.describe "API::DataDevices", :type => :request do
  describe "GET /api_data_devices" do
    it "works! (now write some real specs)" do
      get api_data_devices_path
      expect(response.status).to be(200)
    end
  end
end
