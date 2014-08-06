class UsersController < ApplicationController
  # def index
  #   if current_user.admin?
  #     @users = User.all
  #   else
  #     redirect_to movies_path, notice: "Admin access only!"
  #   end
  # end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id # auto log
      redirect_to movies_path, notice: "Welcome aboard, #{@user.firstname}!"
    else
      render :new
    end
  end

  protected
  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end
end
