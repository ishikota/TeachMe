module AuthenticationHelper
  include SessionsHelper

  # before action
  def signed_in_user
    unless logged_in?
      store_location
      redirect_to login_url unless logged_in?
    end
  end

end
