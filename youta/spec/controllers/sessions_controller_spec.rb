require 'rails_helper'
require 'controllers/helpers'

RSpec.configure do |c|
  c.include ControllerSpecHelpers
end

RSpec.describe SessionsController, :type => :request do

  let(:user) { FactoryGirl.create(:user) }

  describe "#login" do
    context "by not logged-in user" do
      it "should save userid to session when success" do
        log_in(user)
        expect(session[:user_id]).to eq user.id
      end
    end
    context "by already logged-in user" do
      before { log_in(user) }
      it "should redirected to root" do
        get login_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#logout" do
    it "should success" do
      delete logout_path
      expect(session[:user_id]).to be_nil
    end
  end

end
