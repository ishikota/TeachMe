require 'rails_helper'

feature "Users", :type => :feature do

  let!(:user) {
    user = User.create(name: "Kota Ishimoto", student_id: "A1178086", admin: true, password: 'foobar', password_confirmation: 'foobar')
  }
  before {
    visit login_path
    fill_in '学生番号', with: user.student_id
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  }

  describe "#show" do
    it 'should display user information' do
      visit user_path(user)
      expect(page).to have_content user.name
      expect(page).to have_link '編集'
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
    let!(:lecture) { user.lectures.create(title: 'sansu', day_of_week: 0, period: 1) }
    it "should display his lecture" do
      visit management_path
      expect(page).to have_content lecture.title
      expect(page).to have_link '授業を追加', href: new_lesson_path
    end
  end

end
