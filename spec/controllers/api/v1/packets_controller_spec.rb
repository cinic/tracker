require 'rails_helper'
RSpec.describe API::V1::PacketsController, :type => :controller do
  let(:device_data) { FactoryGirl.attributes_for(:packet_85) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # API::DataDevicesController. Be sure to keep this updated too.
  let(:valid_session) { {token: '2ade1fbc924fa19d7fdb6a76e8a5ca9a'} }

  describe '#create' do
    context 'with valid token & params' do
      it 'creates a new Packet' do
        device = create(:device)
        expect {
          post :create, { device_data: device_data, token: '2ade1fbc924fa19d7fdb6a76e8a5ca9a' }, format: :json
        }.to change(Packet, :count).by(1)
      end
    end

    context 'with invalid token' do
      it 'create new packet' do
        post :create, {device_data: device_data}, format: :json
        expect(response.status).to eq(401)
      end
    end
  end
end
