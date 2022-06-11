# frozen_string_literal: true
class RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json
  skip_before_action :authenticate_scope!, only: %i[create update], if: :json_request?
  skip_before_action :require_no_authentication, only: %i[create update], if: :json_request?

  def create
    if json_request?
      create_json
    else
      super
    end
  end

  def create_json
    build_resource(sign_up_params)
    if resource.save
      jwt_token = AuthenticateUser.new(sign_up_params[:email], sign_up_params[:password]).call
      render json: { user: resource, auth_token: "Bearer #{jwt_token}" }
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: { error: resource.errors.full_messages.join(', '), error_code: 4009 }, status: 403
    end
  end

  def update
    if json_request?
      resource = User.find_by_email(account_update_params[:email])
      render json: { error: 'Could not find user', error_code: 4011 }, status: 401 unless resource.present?
    else
      self.resource = begin
                        resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
                      rescue StandardError => e
                        nil
                      end
    end

    if update_resource(resource, account_update_params)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      respond_with resource, location: after_update_path_for(resource) unless json_request?
    else
      clean_up_passwords resource
      if json_request?
        render json: { error: resource.errors.full_messages.join(', '), error_code: 4009 }, status: 403
      else
        respond_with resource
      end
      return
    end

    respond_to do |format|
      format.html
      format.json { render json: { user: resource } }
    end
  end

  protected

  def sign_up_params
    params.require(:user).permit(:email,
                                 :password,
                                 :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:email,
                                 :password,
                                 :password_confirmation,
                                 :current_password)
  end
end
