class Users::Members::ProfileValuesController < ApplicationController
  skip_before_action :ensure_member_profile_exists
  def new
    uuid = session[:team_id]
    @team = Team.find_by(uuid:)
    @member = current_user.members.last
    @profile_value = ProfileValue.new
    @profile_fields = @team.profile_fields
  end

  def create
    uuid = session[:team_id]
    team = Team.find_by(uuid:)

    # paramsから抽出したcontentとチームのprofile_fieldのidのペア配列を返す
    service = ReturnProfileAttributePairsService.new(team, params: create_profile_params)
    field_id_and_value_content_pairs_arr = service.call

    # MembersController#createでsessionに格納した情報
    member = Member.find_by(id: session[:member_id])
    return false unless member

    member.build_profile_values(field_id_and_value_content_pairs_arr)
    # validationに引っ掛からなければ、保存
    if ProfileValue.valid_content?(member)
      member.save_profile_values
      member.save_image(create_profile_params)
      flash[:notice] = I18n.t('notice.members.join_team_successfully', team: team.name)
      redirect_to users_members_teams_path
      # contentのセッション情報は削除
      ProfileValue.reset_content_from_session(team,self)
    else
      # 空だった場合、リダイレクトする（renderではうまくいかなかったため）
      # 他のフィールドに書き込んでいた場合、それは保持しておきたいために、セッションに値を格納しておく
      ProfileValue.set_content_in_session(team, create_profile_params, self)
      flash[:alert] = I18n.t('alert.profile_values.not_empty_content')
      redirect_to new_users_members_profile_value_path
    end
  end

  def edit
    @member=Member.find_by(id:params[:id])
    @team=@member.team
    @profile_values=@member.profile_values
  end

  def update
    member=Member.find_by(id:params[:id])
    team=member.team

    # profile_valueをそれぞれ更新
    update_profile_params[:profile_values].each do |id,value|
      # 空の場合は何もしないので、メソッドを脱出
      if value[:content].blank?
        redirect_to edit_users_members_profile_value_path
        flash[:alert] = I18n.t('alert.profile_values.not_empty_content')
        return
      end
      profile_value=ProfileValue.find_by(id:)
      profile_value.update(content:value[:content])
    end

    # 画像は、この条件をとると、空のparamsを受け入れて画像が消えます
    if update_image_params[:image]
      member.image.attach(update_image_params[:image])
    end

    redirect_to users_members_teams_path
    flash[:notice]=I18n.t("notice.profile_values.update_successfully",team:team.name)
  end


  private

  def create_profile_params
    params.require(:profile_value).permit(:content1, :content2, :content3, :content4, :content5, :content6, :content7, :content8,
                                          :content9, :image)
  end

  def update_profile_params
    # ネストされたprofile_values内のハッシュはcontentキーのみ持てる
    params.permit(profile_values: [:content])
  end

  def update_image_params
    params.permit(:image)
  end

end
