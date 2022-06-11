class API::V1::Auth::AuthenticationController < ApplicationController

  def authenticate
    jwt_token = AuthenticateUser.new(params[:email], params[:password]).call

    if jwt_token.present?
      render json: { auth_token: "Bearer #{jwt_token}" }
    else
      e = APIError::NotAuthorize.new
      render json: { error: e.message, error_code: e.error_code }, status: :unauthorized
    end
  end

  def logout
    @current_user = AuthorizeJwtToken.new(request.headers).call

    if @current_user.present?
      @current_user.update_attribute(:jti, SecureRandom.uuid)
      render json: { success: 'Current token is cancelled.' }
    else
      e = APIError::TokenMissing.new
      render json: { error: e.message, error_code: e.error_code }, status: :unauthorized
    end
  rescue StandardError => e
    render json: { error: e.message, error_code: e.try(:error_code) }, status: :unauthorized
  end
end
