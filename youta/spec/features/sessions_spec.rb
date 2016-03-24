require 'rails_helper'

feature 'Sessions', type: :feature do

  describe "#login" do
    before {
      User.create(name: "Kota Ishimoto", student_id: "A1178086", password: 'foobar', password_confirmation: 'foobar')
    }

    it "should success login" do
      visit login_path
      fill_in '学生番号', with: 'A1178086'
      fill_in 'パスワード', with: 'foobar'
      click_button 'ログイン'
      expect(page).to have_content '授業一覧'
      expect(page).to have_link 'ログアウト', href: logout_path
    end

    it "should failed to login" do
      visit '/login'
      fill_in '学生番号', with: 'A1178086'
      fill_in 'パスワード', with: 'barfoo'
      click_button 'ログイン'
      expect(page).to have_content 'ログインが必要です.'
      expect(page).to have_link 'ログイン', href: login_path
    end
  end

  describe "#logout" do
    before {
      User.create(name: "Kota Ishimoto", student_id: "A1178086", password: 'foobar', password_confirmation: 'foobar')
      visit login_path
      fill_in '学生番号', with: 'A1178086'
      fill_in 'パスワード', with: 'foobar'
      click_button 'ログイン'
      expect(page).to have_content '授業一覧'
      expect(page).to have_link 'ログアウト', href: logout_path
    }

    it "should logout" do
      click_link 'ログアウト'
      expect(page).to have_content 'ログインが必要です.'
      expect(page).to have_link 'ログイン', href: login_path
    end
  end

end
