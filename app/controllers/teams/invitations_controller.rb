class Teams::InvitationsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    team = Team.find_by(uuid: params[:team_id])
    invitation_token = params[:token]
    # トークンに対する認証の処理を行い、ステータスを返すとともに酸化の処理なども行う
    result = TeamInvitationProcessorService.call(team, invitation_token, current_user)
    case result
    when :invalid_token
      flash[:alert] = I18n.t('alert.teams.invitation.invalid_link')
      redirect_to root_path
    when :expired_token
      redirect_to root_path
      flash.now[:alert] = I18n.t('alert.teams.invitation.expired_link')
    when :already_joined
      redirect_to root_path
      flash.now[:alert] = I18n.t('alert.members.prevent_dup_member')
    when :join_team_successfully
      session[:member_id] = current_user.members.last.id
      flash[:notice] = I18n.t('notice.teams.invitation.authenticated_and_join_successfully', team: team.name)
      redirect_to new_users_members_profile_value_path(team_id: team.uuid)
    when :login_or_registration_required
      store_url(invitation_token, team)
      flash[:alert] = I18n.t('alert.teams.invitation.login_or_registration_required')
      redirect_to new_user_session_path
    end
  end

  private

  def store_url(token, team)
    session[:invitation_url] = teams_invitation_url(token:, team_id: team.uuid)
  end
end
