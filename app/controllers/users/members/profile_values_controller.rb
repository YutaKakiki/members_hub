class Users::Members::ProfileValuesController < ApplicationController
  skip_before_action :ensure_member_profile_exists
  def new
    uuid=session[:team_id]
    @team=Team.find_by(uuid:)
  end

end
