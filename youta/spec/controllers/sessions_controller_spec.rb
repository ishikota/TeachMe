require 'rails_helper'
require 'controllers/helpers'

RSpec.configure do |c|
  c.include ControllerSpecHelpers
end

RSpec.describe SessionsController, :type => :request do

  let(:user) { FactoryGirl.create(:user) }
  before { log_in(user) }

  describe "#login" do
    it "should save userid to session when success" do
      expect(session[:user_id]).to eq user.id
    end
  end

  describe "#logout" do
    it "should success" do
      delete logout_path
      expect(session[:user_id]).to be_nil
    end
  end

end
