class Users::Members::ProfilesController < ApplicationController
  skip_before_action :ensure_profile_exists
  def new
    uuid=session[:team_id]
    @team=Team.find_by(uuid:)
  end

end
