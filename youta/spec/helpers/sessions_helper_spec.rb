require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, :type => :helper do
  let!(:user) {
    User.create(name: "Kota Ishimoto", student_id: "A1178086", password: 'foobar', password_confirmation: 'foobar')
  }
  describe "#log_in" do
    it "should save user id to session" do
      helper.log_in(user)
      expect(session[:user_id]).to eq user.id
    end
  end
  describe "#current_user" do
    context "not logged in yet" do
      it { expect(helper.current_user).to be_nil }
      it { expect(helper.logged_in?).to be_falsey }
    end
    context "after logged in" do
      before { helper.log_in user }
      it { expect(helper.current_user).to eq user }
      it { expect(helper.logged_in?).to be_truthy }
    end
  end
  
  describe "#logout" do
    before { helper.log_in user }
    it "should logout" do
      expect { helper.log_out }.to change { helper.current_user}.from(user).to(nil)
    end
  end
end
