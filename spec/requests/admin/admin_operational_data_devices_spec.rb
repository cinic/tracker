require 'rails_helper'

RSpec.describe "Admin::OperationalDataDevices", :type => :request do
  describe "GET /admin_operational_data_devices" do
    it "works! (now write some real specs)" do
      get admin_operational_data_devices_path
      expect(response.status).to be(200)
    end
  end
end
