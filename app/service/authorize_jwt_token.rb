class AuthorizeJwtToken
  attr_reader :headers

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    return @user if @user.present? && JsonWebToken.valid?(http_auth_header)

    raise APIError::CouldNotRetrieveUser
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers['Authorization'].present?
      headers['Authorization'].split(' ').last
    else
      raise APIError::TokenMissing
    end
  end
end
