class SessionsController < ApplicationController
  include Authentication
  allow_unauth only: %i[ login create ]

  def login
  end

  def create
    if user = User.authenticate_by(params.permit(:username, :password))
      session = Session.new
      session.user = user
      session.user_agent = request.user_agent
      session.ip_address = request.remote_ip
      session.save
      cookies.signed.permanent[:session] = { 
        value: session.id, 
        httponly: true, 
        same_site: :strict 
      }

      redirect_to params[:location]
    else
      redirect_to action: "login", alert: "Username or password incorrect", location: params[:location]
    end
  end

  def whoami
  end

  def logout
    Current.session.destroy
    cookies.delete(:session)
    redirect_to "/" #TODO
  end
end
