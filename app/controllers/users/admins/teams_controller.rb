class Users::Admins::TeamsController < ApplicationController
  def index
    @admin_teams = current_user.admin_teams
  end
end
