require 'rails_helper'

RSpec.describe DashboardController, :type => :controller do
  #before(:each) do
  #  current_user = FactoryGirl.create(:user)
  #end
  describe "#index" do
    #it { should redirect_to(login_path) }
    context 'when not logged in' do
      it { get :index; should redirect_to(login_path) }
    end
    context 'when logged in' do
      it { user = FactoryGirl.create(:user); login(user); get :index; expect(response.status).to eq(200) }
    end
  end

end
