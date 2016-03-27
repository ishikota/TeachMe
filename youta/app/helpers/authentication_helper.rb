module AuthenticationHelper
  include SessionsHelper

  # before action
  def signed_in_user
    unless logged_in?
      store_location
      redirect_to login_url, notice: "ログインをしてください"
    end
  end

end
