class Users::AdminsController < ApplicationController
  def update
    team = Team.find_by(id: params[:team_id])
    successor_member = Member.find_by(id: params[:member_id])
    successor_user = successor_member.user
    admin=Admin.find_by(team_id:team.id)
    if admin.update(user_id:successor_user.id)
      flash[:notice] = I18n.t("notice.admin.transfer_admin_role_successfully", team: team.name, member: successor_member.profile_values.first.content)
    else
      flash[:alert] = I18n.t("alert.admin.transfer_admin_role_failed")
    end
    redirect_to team_members_path(team.uuid)
  end

end
