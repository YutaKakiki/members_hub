class Users::Members::TeamsController < ApplicationController
  def index
    @teams = Team.joined_teams(current_user)
  end
end
