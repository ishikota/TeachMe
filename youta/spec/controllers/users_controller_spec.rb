require 'rails_helper'

RSpec.describe UsersController, :type => :request do
  let!(:user) { FactoryGirl.create(:user)}
  before { log_in(user) }

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
    let(:params) { { user: FactoryGirl.attributes_for(:kota) } }
    it "should update user and redirect to my page" do
      put user_path(user), params
      expect(response).to redirect_to user_path(user)
    end
    it "should not update other user's information" do
      other = FactoryGirl.create(:taro)
      expected = other.student_id
      put user_path(other), params
      other.reload
      expect(other.student_id).to eq expected
    end
  end

  describe "#management" do
    let!(:admin) { FactoryGirl.create(:admin) }
    before {
      logout
      log_in(admin)
    }
    it "should assign user's lectures" do
      get management_path
      expect(assigns(:user)).to eq admin
    end
  end


end
