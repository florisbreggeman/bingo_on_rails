class UsersController < ApplicationController

  def edit_password
  end

  def change_password
    current_pw_cond = Current.user.authenticate_password(params["current_password"]) == Current.user
    pw_repeat_cond = params["new_password"] == params["repeat_password"]
    if not current_pw_cond
      redirect_to action: "edit_password", alert: "Current password incorrect"
    elsif not pw_repeat_cond
      redirect_to action: "edit_password", alert: "Passwords did not match"
    else
      Current.user.password = params["new_password"]
      Current.user.save
      redirect_to action: "edit_password", alert: "Password changed successfully"
    end
  end

end
