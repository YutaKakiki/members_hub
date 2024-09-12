class Teams::ProfileFieldsController < ApplicationController
  skip_before_action :ensure_team_profile_exists
  before_action :create_default_fields, only: :new
  before_action { AuthenticateAdmin.call(current_user, params[:team_id], self) }

  # プロフィール一覧（用途的には編集ページ）
  # 新規作成の時と棲み分けをしたかったためアクションを分けている
  def index
    @team = Team.find_by(uuid: params['team_id'])
    @profile_field = ProfileField.new
  end

  def new
    @team = Team.find_by(uuid: params['team_id'])
    @profile_field = ProfileField.new
  end

  def edit
    @profile_field = ProfileField.find_by(id: params[:id])
  end

  def create
    @team = Team.find_by(uuid: params['team_id'])
    return false unless @team

    # プロフィール項目の上限に達していれば、エラーメッセージ
    if ProfileField.limit_profile_fields?(@team)
      flash[:alert] = I18n.t('alert.profile_fields.already_reached_limit', limit: 7)
      redirect_to new_teams_profile_field_path(team_id: @team.uuid)
    else
      @profile_field = @team.profile_fields.build(team_profile_params)
      return if @profile_field.save

      render :new, status: :unprocessable_entity
    end
  end

  def update
    @profile_field = ProfileField.find_by(id: params[:id])
    team = @profile_field.team
    if ProfileField.params_blank?(team_profile_params)
      flash.now[:alert] = I18n.t('alert.profile_fields.not_update_to_blank')
    else
      @profile_field.update(team_profile_params)
      session[:team_of_profile_field_updated_now] = team.uuid
    end
  end

  def destroy
    @team = Team.find_by(uuid: params['team_id'])
    @profile_field = ProfileField.find_by(id: params[:id])
    @profile_field.destroy
  end

  private

  def team_profile_params
    params.require(:profile_field).permit(:name)
  end

  # 最初の項目追加
  def create_default_fields
    @team = Team.find_by(id: session[:team_id])
    ProfileField.create_default_fields(@team)
  end
end
