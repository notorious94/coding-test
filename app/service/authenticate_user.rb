class AuthenticateUser
  attr_accessor :email, :password

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: user&.id) if user
  end

  def user
    user = User.find_by_email(email)
    return user if user&.valid_password?(password)

    nil
  end
end
