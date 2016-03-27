require 'rails_helper'
require 'features/helpers'

RSpec.configure do |c|
  c.include Helpers
end

feature "Users", :type => :feature do

  let!(:user) { FactoryGirl.create(:user) }
  before { log_in(user) }

  describe "#show" do
    let!(:lesson) { user.lessons.create(FactoryGirl.attributes_for(:lesson)) }
    it 'should display user information' do
      visit user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_link '編集'
      expect(page).to have_link nil, href:lesson_questions_path(lesson)
    end
  end

  describe "#edit & #update" do
    let(:new_name) { 'Ishimoto Kota' }
    let(:password) { 'foobar' }
    it "should update user name" do
      visit edit_user_path(user)
      fill_in '名前', with: new_name
      fill_in 'パスワード', with: password
      fill_in 'パスワードの確認', with: password
      click_on '更新'
      expect(page).not_to have_content '登録情報の編集'
      expect(page).to have_content new_name
    end
    it "should fail to update" do
      visit edit_user_path(user)
      fill_in '名前', with: new_name
      fill_in 'パスワード', with: password
      fill_in 'パスワードの確認', with: 'barfoo'
      click_on '更新'
      expect(page).to have_content '登録情報の編集'
    end
  end

  describe "#manage" do
    let!(:lecture) { user.lectures.create(FactoryGirl.attributes_for(:lesson)) }
    it "should display his lecture" do
      visit management_path
      expect(page).to have_content lecture.title
      expect(page).to have_link '授業を追加', href: new_lesson_path
      expect(page).to have_link nil, href: edit_lesson_path(lecture)
    end
  end

  describe "authentication" do
    before {
      visit root_path
      click_link "ログアウト"
    }

    it { require_login_and_friendly_forward user, user_url(user)}
    it { require_login_and_friendly_forward user, edit_user_url(user)}
    it { require_login_and_friendly_forward user, management_url(user)}
  end

end
