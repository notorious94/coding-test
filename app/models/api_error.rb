module APIError
  class AnotherUserLoggedIn < StandardError
    def error_code
      2001
    end

    def message
      'Already a different user is signed in. Please log out and try again.'
    end
  end

  class CouldNotRetrieveUser < StandardError
    def error_code
      2002
    end

    def message
      'Could not retrieve user with token!'
    end
  end

  class TokenExpired < StandardError
    def error_code
      3001
    end

    def message
      'Token Expired! Please log in again.'
    end
  end

  class TokenNotValidAnymore < StandardError
    def error_code
      3002
    end

    def message
      'Token is not valid anymore! Please log in again.'
    end
  end

  class TokenMissing < StandardError
    def error_code
      3003
    end

    def message
      'Token Missing. Add correct token to request header as "Authorization".'
    end
  end

  class NotAuthorize < StandardError
    def error_code
      4003
    end

    def message
      'Not Authorized'
    end
  end

  class InternalServerError < StandardError
    def error_code
      5001
    end

    def message
      'Internal Server Error.'
    end
  end

  class ApiAccessTokenError < StandardError
    def error_code
      4020
    end

    def message
      "Request header should have a key #{AuthenticateAccessToken::API_ACCESS_TOKEN_KEY} with valid api access token"
    end
  end

end
