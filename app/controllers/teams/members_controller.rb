class Teams::MembersController < ApplicationController
  before_action :member_of_team?

  def index
    @team = Team.where(uuid: params[:team_id]).includes(:profile_fields, :member_users).first
    # 画像、プロフィール項目内容をまとめて取得（N+1の解消）
    @members = Member.page(params[:page]).per(10).where(team_id: @team.id).includes(:image_attachment, :profile_values) if @team
    @profile_fields = @team.profile_fields
  end

  def show
    @team = Team.where(uuid: params[:team_id]).includes(:profile_fields).first
    @member = Member.where(id: params[:id]).includes(:profile_values, :image_attachment).first
  end

  private

  def member_of_team?
    team = Team.find_by(uuid: params[:team_id])
    return false if Member.member_of_team?(current_user, team)

    flash[:alert] = I18n.t('alert.members.please_join')
    redirect_to new_users_member_path
  end
end
