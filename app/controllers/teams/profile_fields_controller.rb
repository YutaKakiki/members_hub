class Teams::ProfileFieldsController < ApplicationController
  skip_before_action :ensure_team_profile_exists
  before_action :create_default_fields,only: :new

  def new
    @profile_field=ProfileField.new
  end

  def create
    @team=Team.find_by(id:session[:team_id])
    return false unless @team
    @profile_field=@team.profile_fields.build(team_profile_params)
    if @profile_field.save
      last_profile_field=@team.profile_fields.last
    end
  end

  def destroy
    @team=Team.find_by(id:session[:team_id])
    return false unless @team
    @profile_field=@team.profile_fields.delete(params[:id])
  end


  private
  def team_profile_params
    params.require(:profile_field).permit(:field)
  end

  # 最初の項目追加
  def create_default_fields
    @team=Team.find_by(id:session[:team_id])
    return false unless @team
    unless @team.profile_fields.exists?(field: "名前") && @team.profile_fields.exists?(field: "生年月日")
      @team.profile_fields.create(field:"名前")
      @team.profile_fields.create(field:"生年月日")
    end
  end
end
