class Users::Members::ProfileValuesController < ApplicationController
  skip_before_action :ensure_member_profile_exists
  def new
    uuid = session[:team_id]
    @team = Team.find_by(uuid:)
    @profile_value=ProfileValue.new
    @profile_fields=@team.profile_fields
  end

  def create
    uuid = session[:team_id]
    team = Team.find_by(uuid:)
    field_and_content_pairs_arr= ProfileValue.create_field_and_content_pairs_arr(member_profile_params,team)
    # MembersController#createでsessionに格納した情報
    member=Member.find_by(id:session[:member_id])
    return false unless member
    profile_values=member.build_profile_values(field_and_content_pairs_arr)
    # validationに引っ掛からなければ、保存
    if member.has_valid_content?
      member.save_profile_values
      flash[:notice]=I18n.t("notice.members.join_team_successfully",team:team.name)
      redirect_to users_members_teams_path
      # contentのセッション情報は削除
      ProfileValue.reset_content_from_session(self)
    else
      # 空だった場合、リダイレクトする（renderではうまくいかなかったため）
      # 他のフィールドに書き込んでいた場合、それは保持しておきたいために、セッションに値を格納しておく
      ProfileValue.set_content_in_session(member_profile_params,self)
      flash[:alert]=I18n.t("alert.profile_values.not_empty_content")
      redirect_to new_users_members_profile_value_path
    end
  end

  private
    def member_profile_params
      params.require(:profile_value).permit(:content_1,:content_2,:content_3,:content_4,:content_5)
    end

end
