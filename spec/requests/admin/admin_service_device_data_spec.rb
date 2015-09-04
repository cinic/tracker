require 'rails_helper'

RSpec.describe "Admin::ServiceDeviceData", :type => :request do
  describe "GET /admin_service_device_data" do
    it "works! (now write some real specs)" do
      get admin_service_device_data_path
      expect(response.status).to be(200)
    end
  end
end
