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
    visit user_path(user)
  }

  it 'should display user information' do
    expect(page).to have_content user.name
    expect(page).to have_button '編集'
  end

end
