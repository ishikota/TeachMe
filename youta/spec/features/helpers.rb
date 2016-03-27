module Helpers
  def log_in(user)
    visit login_path
    fill_in '学生番号', with: user.student_id
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end
end
