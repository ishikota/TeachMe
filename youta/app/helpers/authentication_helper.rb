module AuthenticationHelper
  include SessionsHelper

  # before action
  def signed_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインをしてください"
      redirect_to login_url
    end
  end

  def admin_user
    unless logged_in? && current_user.admin?
      flash[:danger] = "管理者権限が必要です"
      redirect_to root_path
    end
  end

end
