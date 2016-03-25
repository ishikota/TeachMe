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

end
