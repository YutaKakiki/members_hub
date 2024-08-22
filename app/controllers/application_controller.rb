class ApplicationController < ActionController::Base
  before_action :ensure_profile_exists

  private
    def ensure_profile_exists
      EnsureProfileExists.new(session[:member_id],self).callback
    end
end
