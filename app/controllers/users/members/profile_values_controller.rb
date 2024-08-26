class Users::Members::ProfileValuesController < ApplicationController
  skip_before_action :ensure_member_profile_exists
  def new
    uuid = session[:team_id]
    @team = Team.find_by(uuid:)
    @profile_value=ProfileValue.new
    @profile_fields=@team.profile_fields
  end

  def create
    # MembersController#createでsessionに格納した情報
    member=Member.find_by(id:session[:member_id])
    # TODO: 以下のロジックはモデルに切り出す
    member_profile_params_count=member_profile_params.keys.count
    contents=[]
    member_profile_params_count.times do |i|
      contents.push(member_profile_params["content_#{i+1}"])
    end
    uuid = session[:team_id]
    @team = Team.find_by(uuid:)
    profile_field_ids=@team.profile_field_ids
    if contents.size==profile_field_ids.size
      field_contents=contents.zip(profile_field_ids)
      field_contents.each do |content,profile_field_id|
        member.profile_values.create({content:,profile_field_id:})
      end
    end
    flash[:notice]=I18n.t("notice.members.join_team_successfully",team:@team.name)
    redirect_to users_members_teams_path
  end

  private
    def member_profile_params
      params.require(:profile_value).permit(:content_1,:content_2,:content_3,:content_4,:content_5)
    end

end
