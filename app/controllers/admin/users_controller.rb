class Admin::UsersController < ApplicationController
  before_filter :admin_only

  def index
    if current_user.admin?
      @users = User.all
    else
      redirect_to movies_path, notice: "Admin access only!"
    end
  end

  protected

  def admin_only
    if !current_user.admin?
      flash[:alert] = "You must be an admin to access that page."
      redirect_to movies_path
    end
  end
end
