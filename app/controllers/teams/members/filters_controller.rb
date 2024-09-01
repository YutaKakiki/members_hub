class Teams::Members::FiltersController < ApplicationController

  def index
    @team=Team.find_by(uuid:params[:team_id])
    @profile_fields=@team.profile_fields
    @filtered_members = FilterMembersService.new(filter_params).call
    @members = @filtered_members.page(params[:page]).per(10) if @filtered_members

  end

  private

  def filter_params
    # field~、value~のみを許可
    profile_params = params.select { |key, _| key.to_s.start_with?('field') || key.to_s.start_with?("value")}
    params.permit(profile_params.keys, :team_id)
  end

end
