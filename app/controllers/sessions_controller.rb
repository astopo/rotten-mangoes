class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authentication(params[:password])
      session[:user_id] = user_id
      redirect_to movies_path
    else
      render :new
    end
  end
end
