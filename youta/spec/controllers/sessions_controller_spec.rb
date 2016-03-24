require 'rails_helper'

RSpec.describe SessionsController, :type => :request do

  let!(:user) {
    User.create(name: "Kota Ishimoto", student_id: "A1178086", password: "foobar", password_confirmation: "foobar")
  }
  let(:params) {
    { session: { student_id: "A1178086", password: 'foobar' } }
  }

  describe "POST login" do
    it "should save userid to session when success" do
      post login_path, params
      expect(session[:user_id]).to eq user.id
    end
  end

  describe "DELETE logout" do
    it "should logout" do
      post login_path, params
      delete logout_path
      expect(session[:user_id]).to be_nil
    end
  end

end
