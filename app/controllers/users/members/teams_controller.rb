class Users::Members::TeamsController < ApplicationController
  def index
    @teams = current_user.teams.includes(logo_attachment: :blob)
  end
end
