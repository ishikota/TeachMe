class UsersController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, except: :manage
  before_action :admin_user, only: :manage

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      #TODO flash
      redirect_to user_path(@user)
    else
      #TODO flash
      render 'edit'
    end
  end

  def manage
    @user = current_user
  end

  private
    def user_params
      params.require(:user).permit(:student_id, :name, :password, :password_confirmation)
    end

    # before_action
    def correct_user
      @user = User.find(params[:id])
      unless logged_in? && current_user == @user
        redirect_to root_path, notice: "不正なアクセスです"
      end
    end
end
