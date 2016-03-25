require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  let!(:user) {
    User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_confirmation: 'foobar')
  }

  describe "#show" do
    it "should assign user" do
      #TODO get user_path(user) raises No route matches {:action=>"/users/1", :controller=>"users"}
      get :show, id: user.id
      expect(assigns(:user)).to eq user
    end
  end

  describe "#edit" do
    it "should assign user" do
      #TODO get user_path(user) raises No route matches {:action=>"/users/1", :controller=>"users"}
      get :edit, id: user.id
      expect(assigns(:user)).to eq user
    end
  end

  describe "#update" do
    it "should update user and redirect to my page" do
      params = { user: { student_id: "a1178086", name: "Kota", password: 'foobar', password_confirmation: 'foobar' } }
      pending 'No route matches {:action=>"/users/1", :controller=>"users",...'
      put user_path(user), params
      expect(response).to redirect_to :show
    end
  end


end
