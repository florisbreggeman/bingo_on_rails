class SessionsController < ApplicationController

  def login
  end

  def create
    if user = User.authenticate_by(params.permit(:username, :password))
      redirect_to "/"  # TODO actually make a session
    else
      redirect_to "/login"  # TODO figure out alerts
    end
  end

  def destroy
    # TODO
  end
end
