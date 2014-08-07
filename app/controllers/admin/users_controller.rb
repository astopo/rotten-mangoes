class Admin::UsersController < ApplicationController
  before_filter :admin_only

  def index
    if current_user.admin?
      all = User.all
      @users = all.page(params[:page]).per(1)
    else
      redirect_to movies_path, notice: "Admin access only!"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "#{@user.firstname} created"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to  do |format|
      UserMailer.delete_email(@user).deliver
      format.html { redirect_to(admin_users_path, notice: 'User was successfully deleted.') }
    end
  end

  protected

  def admin_only
    if !current_user.admin?
      flash[:alert] = "You must be an admin to access that page."
      redirect_to movies_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end
end
