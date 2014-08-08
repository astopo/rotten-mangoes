class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception 

  protected

  def restrict_access
    if !current_user
      flash[:alert] = "You must log in."
      redirect_to new_session_path
    end
  end

  def current_user
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
    # if @current_user.admin == true && session[:preview]
    #   @current_user = User.find(id)
    #   binding.pry
    # end
    @current_user
  end

  def admin_only
    if !current_user.admin?
      flash[:alert] = "You must be an admin to access that page."
      redirect_to movies_path
    end
  end

  def is_actually_admin
    current_user.admin?
  end

  def check_preview_as
    if params[:preview_as] && is_actually_admin
      session[:user_id] = params[:preview_as]
      current_user
    else
      session[:user_id] = session[:actual_user]
      current_user
    end
    @movies = Movie.all
    render :index
  end

  helper_method :current_user, :admin_only, :is_actually_admin, :check_preview_as
end
