module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
  end

  class_methods do
     def allow_unauth(**options)
       skip_before_action :require_authentication, **options
     end
  end

  private

    def require_authentication
      session_cookie = cookies.signed[:session]
      if session_cookie == nil
        redirect_to action: "login", location: request.path
      else
        session = Session.find_by(id: session_cookie)
        Current.user = session.user
      end
    end
end
