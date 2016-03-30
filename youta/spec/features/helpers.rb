module Helpers
  def log_in(user, visit=true)
    visit login_path if visit
    fill_in '学生番号', with: user.student_id
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  def require_login_and_friendly_forward(user, url)
    visit url
    expect(page).to have_content 'ログインをしてください'
    log_in(user, visit=false)
    expect(current_url).to eq url
  end

  def require_admin_and_redirect(url)
    visit url
    expect(page).to have_content '管理者権限が必要です'
    expect(current_url).to eq root_url
  end

end
