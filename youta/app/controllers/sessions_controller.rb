class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(student_id: params[:session][:student_id].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_back_or lessons_path
    else
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
