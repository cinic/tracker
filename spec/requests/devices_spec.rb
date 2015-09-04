require 'rails_helper'

RSpec.describe "Devices", :type => :request do
  describe "GET /devices" do
    it "works! (now write some real specs)" do
      get devices_path
      expect(response.status).to be(200)
    end
  end
end
