module Helpers
  def log_in(user, visit=true)
    visit login_path if visit
    fill_in '学生番号', with: user.student_id
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  def require_login_and_friendly_forward(user, url)
    visit url
    log_in(user, visit=false)
    expect(current_url).to eq url
  end
end
