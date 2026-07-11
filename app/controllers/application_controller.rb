class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include Authentication
  before_action :set_menu_items

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def set_menu_items
    menu_items_always = [{title: "All Cards", path: "/"}]
    menu_items_unauth = [{title: "Log in", path: "/login?location=#{CGI.escape request.path}"}]
    menu_items_auth = [{title: "Who am I?", path: "/whoami"}, {title: "New Card", path: "/new"}, {title: "Log out", path: "/logout", method: "post"}]

    if Current.user == nil
      @menu_items = menu_items_always + menu_items_unauth
    else
      @menu_items = menu_items_always + menu_items_auth
    end

    @menu_items.map do |item| 
      if item[:path] == request.path
        item[:selected] = true
        item[:path] = "#"
      else
        item[:selected] = false
      end
      item[:method] ||= "get"
    end
  end
end
