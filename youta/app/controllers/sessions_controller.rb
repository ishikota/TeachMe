class SessionsController < ApplicationController
  before_action :need_login, only: [:new, :create]
  def new
  end
  def create
    user = User.find_by(student_id: params[:session][:student_id].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_back_or lessons_path
    else
      flash.now[:danger] = "学生番号，もしくはパスワードが間違っています"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end

  private
    def need_login
      redirect_to root_path if logged_in?
    end
end
