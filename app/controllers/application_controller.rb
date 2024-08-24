class ApplicationController < ActionController::Base
  before_action :ensure_member_profile_exists
  before_action :ensure_team_profile_exists

  private

  def ensure_member_profile_exists
    EnsureMemberProfileExists.new(session[:member_id], self).callback
  end

  def ensure_team_profile_exists
    EnsureTeamProfileExists.new(session[:team_id], self).callback
  end
end
