class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request?
  before_action :authenticate_user!, unless: :json_request?
  before_action :authorize_api_token

  def json_request?
    request.format.json?
  end

  def authorize_api_token
    return false unless json_request?

    has_valid_access_token = AuthenticateAccessToken.new(request.headers).call
    return true if has_valid_access_token

    e = APIError::ApiAccessTokenError.new
    render json: { error: e.message, error_code: e.error_code }, status: 401
  end

end
