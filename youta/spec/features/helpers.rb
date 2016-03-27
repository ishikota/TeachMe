module Helpers
  def log_in(user, visit=true)
    visit login_path if visit
    fill_in '学生番号', with: user.student_id
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end
end
