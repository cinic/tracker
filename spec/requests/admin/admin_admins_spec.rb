require 'rails_helper'

RSpec.describe "Admin::Admins", :type => :request do
  describe "GET /admin_admins" do
    it "works! (now write some real specs)" do
      get admin_admins_path
      expect(response.status).to be(200)
    end
  end
end
