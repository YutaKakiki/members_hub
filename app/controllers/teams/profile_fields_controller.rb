class Teams::ProfileFieldsController < ApplicationController
  skip_before_action :ensure_team_profile_exists
  before_action :create_default_fields, only: :new

  def new
    @team = Team.find_by(id: session[:team_id])
    @profile_field = ProfileField.new
  end

  def create
    @team = Team.find_by(id: session[:team_id])
    return false unless @team

    # プロフィール項目の上限に達していれば、エラーメッセージ
    if ProfileField.limit_profile_fields?(@team)
      flash[:alert] = I18n.t('alert.profile_fields.already_reached_limit', limit: 7)
      redirect_to new_teams_profile_field_path
    else
      @profile_field = @team.profile_fields.build(team_profile_params)
      return if @profile_field.save

      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @team = Team.find_by(id: session[:team_id])
    return false unless @team

    @profile_field = @team.profile_fields.delete(params[:id])
  end

  private

  def team_profile_params
    params.require(:profile_field).permit(:name)
  end

  # 最初の項目追加
  def create_default_fields
    @team = Team.find_by(id: session[:team_id])
    return false unless @team

    return if @team.profile_fields.exists?(name: '名前') && @team.profile_fields.exists?(name: '生年月日')

    @team.profile_fields.create(name: '名前')
    @team.profile_fields.create(name: '生年月日')
  end
end
