class Teams::MembersController < ApplicationController
  def index
    @team = Team.find_by(uuid: params[:team_id])
    # 画像、プロフィール項目内容をまとめて取得（N+1の解消）
    if @team
      @members = Member.page(params[:page]).per(10).where(team_id: @team.id).includes(:profile_values,
                                                                                      image_attachment: :blob)
    end
    @profile_fields = @team.profile_fields
  end

  def show
    @team = Team.find_by(uuid: params[:team_id])
    @member = Member.find_by(id: params[:id])
  end
end
