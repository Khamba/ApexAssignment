class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :guest

  private

    def guest
      @guest = Guest.find_by token: cookies[:guest_token]
      return @guest if @guest # already logged in, don't need to create another one
      @guest = Guest.create
      cookies[:guest_token] = @guest.token
    end

end
