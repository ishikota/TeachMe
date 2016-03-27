require 'rails_helper'

RSpec.describe UsersController, :type => :request do
  let!(:user) { FactoryGirl.create(:user)}

  describe "#show" do
    it "should assign user" do
      get user_path(user)
      expect(assigns(:user)).to eq user
    end
  end

  describe "#edit" do
    it "should assign user" do
      get edit_user_path(user)
      expect(assigns(:user)).to eq user
    end
  end

  describe "#update" do
    it "should update user and redirect to my page" do
      params = { user: { student_id: "a1178086", name: "Kota", password: 'foobar', password_confirmation: 'foobar' } }
      put user_path(user), params
      expect(response).to redirect_to user_path(user)
    end
  end

  describe "#management" do
    before { log_in(user) }
    it "should assign user's lectures" do
      get management_path
      expect(assigns(:user)).to eq user
    end
  end


end
