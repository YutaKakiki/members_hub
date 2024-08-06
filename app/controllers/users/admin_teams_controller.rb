class Users::AdminTeamsController < ApplicationController
  def index
    @admin_teams = current_user.admin_teams
  end
end
