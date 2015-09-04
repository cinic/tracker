require 'rails_helper'

RSpec.describe Admin::DashboardController, :type => :controller do
  
  describe "#show" do
    context "admin not signed in" do
      it "redirect to admin login url" do
        get :show
        expect(response).to redirect_to admin_login_url
      end
    end

    context "admin signed in" do
      before do
        @user = FactoryGirl.create(:admin_admin)
        sign_in_admin @user
      end

      it "succeeds and renders show" do
        get :show
        expect(response).to be_success
        expect(response).to render_template(:show)
      end
    end
  end

end
