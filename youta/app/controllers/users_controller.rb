class UsersController < ApplicationController
  before_action :signed_in_user

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
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
end
