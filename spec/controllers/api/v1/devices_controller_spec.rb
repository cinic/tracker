require 'rails_helper'
RSpec.describe API::V1::DevicesController, :type => :controller do

  let(:valid_attributes) {
    FactoryGirl.new(:device)
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # API::DataDevicesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all api_data_devices as @api_data_devices" do
      data_device = Device.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:api_data_devices)).to eq([data_device])
    end
  end

  describe "GET show" do
    it "assigns the requested api_data_device as @api_data_device" do
      data_device = API::DataDevice.create! valid_attributes
      get :show, {:id => data_device.to_param}, valid_session
      expect(assigns(:api_data_device)).to eq(data_device)
    end
  end

  describe "GET new" do
    it "assigns a new api_data_device as @api_data_device" do
      get :new, {}, valid_session
      expect(assigns(:api_data_device)).to be_a_new(API::DataDevice)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new API::DataDevice" do
        expect {
          post :create, {:api_data_device => valid_attributes}, valid_session
        }.to change(API::DataDevice, :count).by(1)
      end

      it "assigns a newly created api_data_device as @api_data_device" do
        post :create, {:api_data_device => valid_attributes}, valid_session
        expect(assigns(:api_data_device)).to be_a(API::DataDevice)
        expect(assigns(:api_data_device)).to be_persisted
      end

      it "redirects to the created api_data_device" do
        post :create, {:api_data_device => valid_attributes}, valid_session
        expect(response).to redirect_to(API::DataDevice.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved api_data_device as @api_data_device" do
        post :create, {:api_data_device => invalid_attributes}, valid_session
        expect(assigns(:api_data_device)).to be_a_new(API::DataDevice)
      end

      it "re-renders the 'new' template" do
        post :create, {:api_data_device => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end
end
