class Teams::MembersController < ApplicationController
  def index
    @team = Team.find_by(uuid:params[:team_id])
    # 画像、プロフィール項目内容をまとめて取得（N+1の解消）
    @members = Member.where(team_id: @team.id).includes(:profile_values, image_attachment: :blob) if @team
  end

  def show
    @team = Team.find_by(uuid:params[:team_id])
    @member=Member.find_by(id:params[:id])
  end
end
