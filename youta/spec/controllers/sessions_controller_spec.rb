require 'rails_helper'

RSpec.describe SessionsController, :type => :request do

  describe "GET new" do
    it "returns http success" do
      get '/login'
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST login" do
    let(:params) {
      { session: { student_id: "A1178086", password: 'foobar' } }
    }
    let!(:user) {
      User.create(name: "Kota Ishimoto", student_id: "A1178086", password: "foobar", password_confirmation: "foobar")
    }
    it "should save userid to session when success" do
      post login_path, params
      expect(session[:user_id]).to eq user.id
    end
  end

end
