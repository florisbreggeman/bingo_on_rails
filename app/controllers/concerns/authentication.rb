module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :fetch_authentication, :require_authentication
  end

  class_methods do
     def allow_unauth(**options)
       skip_before_action :require_authentication, **options
     end
  end

  private

    def fetch_authentication
      session_cookie = cookies.signed[:session]
      if session_cookie != nil
        session = Session.find_by(id: session_cookie)
        Current.session = session
        Current.user = session.user
      end
    end

    def require_authentication
      if Current.user == nil
        redirect_to action: "login", controller: "sessions", location: request.path
      end
    end

    def destroy_authentication
      session_cookie = cookies.signed[:session]
      if session_cookie != nil
        Session.find_by(id: session_cookie).destroy
      end
    end
end
