require 'rails_helper'
require 'features/helpers'

RSpec.configure do |c|
  c.include Helpers
end

feature 'Sessions', type: :feature do
  let!(:user) { FactoryGirl.create(:user) }

  describe "#login" do
    context "success" do
      before { log_in(user) }
      it "should have logout link" do
        expect(page).to have_content '授業一覧'
        expect(page).to have_link 'ログアウト', href: logout_path
      end
    end
    context "failure" do
      before {
        user.password = "barfoo"
        log_in(user)
      }
      it "should still have login path" do
        expect(page).to have_content 'ログインが必要です.'
      end
    end
  end

  describe "#logout" do
    before { log_in(user) }
    it "should success" do
      click_link 'ログアウト'
      expect(page).to have_content 'ログインが必要です.'
    end
  end

end
