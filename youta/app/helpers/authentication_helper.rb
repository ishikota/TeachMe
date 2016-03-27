module AuthenticationHelper
  include SessionsHelper

  # before action
  def signed_in_user
    unless logged_in?
      store_location
      redirect_to login_url, notice: "ログインをしてください"
    end
  end

  def admin_user
    unless logged_in? && current_user.admin?
      redirect_to root_path, notice: "管理者権限が必要です"
    end
  end

end
