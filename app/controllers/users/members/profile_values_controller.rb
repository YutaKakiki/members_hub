class Users::Members::ProfileValuesController < ApplicationController
  skip_before_action :ensure_member_profile_exists

  def new
    @team = Team.find_by(uuid: params['team_id'])
    @member = current_user.members.last
    @profile_value = ProfileValue.new
    @profile_fields = @team.profile_fields if @team
  end

  def edit
    @member = Member.find_by(id: params[:id])
    @team = @member.team
    @profile_values = @member.profile_values
    # Teamが新たに追加したプロフィール項目を取得（かつ、メンバーが記入していない項目）
    @unfilled_profile_fields = ProfileField.unfilled_profile_field(@team, @member)
    # 新たに追加された項目を作成するための新規インスタンスを用意
    @unfilled_profile_values = ProfileValue.new
  end

  def create
    team = Team.find_by(uuid: params['team_id'])
    # MembersController#createでsessionに格納した情報
    member = Member.find_by(id: session[:member_id])
    return false unless member
    # paramsから抽出したcontentとチームのprofile_fieldのidのペア配列を返す
    service=ReturnProfileAttributePairsService.new(team, params: create_profile_params)
    field_id_and_value_content_pairs_arr = service.call
    member.build_profile_values(field_id_and_value_content_pairs_arr)
    # validationに引っ掛からなければ、保存
    if ProfileValue.valid_content?(member)
      member.save_profile_values
      member.save_image(create_profile_params)
      flash[:notice] = I18n.t('notice.members.join_team_successfully', team: team.name)
      redirect_to users_members_teams_path
      # contentのセッション情報は削除
      reset_content_from_session(team)
    else
      # 空だった場合、リダイレクトする（renderではうまくいかなかったため）
      # 他のフィールドに書き込んでいた場合、それは保持しておきたいために、セッションに値を格納しておく
      set_content_in_session(team, create_profile_params)
      flash[:alert] = I18n.t('alert.profile_values.not_empty_content')
      redirect_to new_users_members_profile_value_path(team_id: team.uuid)
    end
  end

  def update
    # 空のcontentがあれば更新しない
    if params_content_blank?(update_profile_params) == :content_blank
      redirect_to edit_users_members_profile_value_path
      flash[:alert] = I18n.t('alert.profile_values.not_empty_content')
      return
    else
      ProfileValue.update_profile_values(update_profile_params)
    end

    # unfilled_profile_valuesがパラメータに含まれていた場合は、新たにその項目をcreateする
    member = Member.find_by(id: params[:id])
    ProfileValue.create_unfilled_profile(create_unfilled_profile_params,member)

    # 画像は、このif条件をとると、空のparamsを受け入れてしまい画像が消えます
    member.save_image(update_image_params)

    team = member.team
    flash[:notice] = I18n.t('notice.profile_values.update_successfully', team: team.name)
    redirect_to users_members_teams_path
  end

  private

    def create_profile_params
      params.require(:profile_value).permit(:content1, :content2, :content3, :content4, :content5, :content6, :content7, :content8,
                                            :content9, :image)
    end

    def create_unfilled_profile_params
      params.permit(unfilled_profile_values: [:profile_field_id, :content])
    end

    def update_image_params
      params.permit(:image)
    end

    def update_profile_params
      # ネストされたprofile_values内のハッシュはcontentキーのみ持てる
      params.permit(profile_values: [:content])
    end

    def params_content_blank?(params)
      params[:profile_values].each do |id,value|
        if value[:content].blank?
          return :content_blank
        end
      end
    end

    def reset_content_from_session(team)
      content_count = team.profile_fields.count
      content_count.times do |i|
        session["content#{i + 1}"] = nil
      end
    end

    def set_content_in_session(team, params)
      content_count = team.profile_fields.count
      content_count.times do |i|
        session["content#{i + 1}"] = params["content#{i + 1}"]
      end
    end
end
