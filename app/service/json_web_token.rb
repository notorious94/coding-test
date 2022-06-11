class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:expires_at] = exp
      payload[:jti] = SecureRandom.uuid
      final_token = JWT.encode(payload, ENV['DEVISE_JWT_SECRET_KEY'])
      User.find(payload[:user_id]).update_attribute(:jti, payload[:jti]) if final_token.present?
      final_token
    end

    def decode(token)
      body = JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY'])[0]
      HashWithIndifferentAccess.new body
    rescue StandardError
      nil
    end

    def valid?(token)
      token_body = decode(token)
      expiration_time = token_body['expires_at'].to_time

      raise APIError::TokenExpired if Time.now > expiration_time

      jti = token_body['jti']
      user_id = token_body['user_id']

      raise APIError::TokenNotValidAnymore if User.find(user_id).jti != jti

      true
    end
  end
end
