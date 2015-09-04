require 'rails_helper'

RSpec.describe Admin::AdminsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Admin::Admin. As you add validations to Admin::Admin, be sure to
  # adjust the attributes here as well.
  before do
    @user = FactoryGirl.create(:admin_admin)
    sign_in_admin @user
  end

  let(:valid_attributes) { FactoryGirl.attributes_for(:admin_admin, email: "test201@test.com") }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:admin_admin, email: "") }
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Admin::AdminsController. Be sure to keep this updated too.
  let(:valid_session) {}

  describe "GET index" do
    it "assigns all admin_admins as @admin_admins" do
      get :index, {}, valid_session
      expect(response.status).to eq(200)
      expect(assigns(:admin_admins)).to eq([@user])
    end
  end

  describe "GET show" do
    it "assigns the requested admin_admin as @admin_admin" do
      admin = Admin::Admin.create! valid_attributes
      get :show, {:id => admin.to_param}, valid_session
      expect(assigns(:admin_admin)).to eq(admin)
    end
  end

  describe "GET new" do
    it "assigns a new admin_admin as @admin_admin" do
      get :new, {}, valid_session
      expect(assigns(:admin_admin)).to be_a_new(Admin::Admin)
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_admin as @admin_admin" do
      admin = Admin::Admin.create! valid_attributes
      get :edit, {:id => admin.to_param}, valid_session
      expect(assigns(:admin_admin)).to eq(admin)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin::Admin" do
        expect {
          post :create, {:admin_admin => valid_attributes}, valid_session
        }.to change(Admin::Admin, :count).by(1)
      end

      it "assigns a newly created admin_admin as @admin_admin" do
        post :create, {:admin_admin => valid_attributes}, valid_session
        expect(assigns(:admin_admin)).to be_a(Admin::Admin)
        expect(assigns(:admin_admin)).to be_persisted
      end

      it "redirects to the created admin_admin" do
        post :create, {:admin_admin => valid_attributes}, valid_session
        expect(response).to redirect_to(Admin::Admin.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin_admin as @admin_admin" do
        post :create, {:admin_admin => invalid_attributes}, valid_session
        expect(assigns(:admin_admin)).to be_a_new(Admin::Admin)
      end

      it "re-renders the 'new' template" do
        post :create, {:admin_admin => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        FactoryGirl.attributes_for(:admin_admin, email: "test201@test.com")
      }

      it "updates the requested admin_admin" do
        admin = Admin::Admin.create! valid_attributes
        put :update, {:id => admin.to_param, :admin_admin => new_attributes}, valid_session
        admin.reload
        expect(assigns(:admin_admin)).to eq(admin)
      end

      it "assigns the requested admin_admin as @admin_admin" do
        admin = Admin::Admin.create! valid_attributes
        put :update, {:id => admin.to_param, :admin_admin => valid_attributes}, valid_session
        expect(assigns(:admin_admin)).to eq(admin)
      end

      it "redirects to the admin_admin" do
        admin = Admin::Admin.create! valid_attributes
        put :update, {:id => admin.to_param, :admin_admin => valid_attributes}, valid_session
        expect(response).to redirect_to(admin)
      end
    end

    describe "with invalid params" do
      it "assigns the admin_admin as @admin_admin" do
        admin = Admin::Admin.create! valid_attributes
        put :update, {:id => admin.to_param, :admin_admin => invalid_attributes}, valid_session
        expect(assigns(:admin_admin)).to eq(admin)
      end

      it "re-renders the 'edit' template" do
        admin = Admin::Admin.create! valid_attributes
        put :update, {:id => admin.to_param, :admin_admin => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested admin_admin" do
      admin = Admin::Admin.create! valid_attributes
      expect {
        delete :destroy, {:id => admin.to_param}, valid_session
      }.to change(Admin::Admin, :count).by(-1)
    end

    it "redirects to the admin_admins list" do
      admin = Admin::Admin.create! valid_attributes
      delete :destroy, {:id => admin.to_param}, valid_session
      expect(response).to redirect_to(admin_admins_url)
    end
  end

end
