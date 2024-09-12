# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :authenticate_user!
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # 　オーバーライドする
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      flash[:notice] = I18n.t('devise.confirmations.confirmed.signin')
      # ログインさせる
      sign_in(resource)
      url = after_confirmation_path_for(resource_name, resource)
      respond_with_navigational(resource) { redirect_to url }
    else
      # TODO: use `error_status` when the default changes to `:unprocessable_entity`.
      respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if (invitation_url = session[:invitation_url])
      session[:invitation_url] = nil
      invitation_url
    else
      super
    end
  end
end
