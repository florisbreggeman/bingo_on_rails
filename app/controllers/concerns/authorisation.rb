module Authorisation
  extend ActiveSupport::Concern

  included do
    before_action :require_authorisation
  end

  class_methods do
     def no_authorisation(**options)
       skip_before_action :require_authorisation, **options
     end
  end

  private

    def require_authorisation
      @card = Card.find_by(params[:id])
      if @card == nil or @card.user_id != Current.user.id
        render status: 403, file: "#{Rails.root}/public/403.html", layout: false
      end
    end

end
