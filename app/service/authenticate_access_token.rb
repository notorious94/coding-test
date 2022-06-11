class AuthenticateAccessToken
  attr_accessor :headers

  API_ACCESS_TOKEN_KEY = 'Api-Access-Token'.freeze

  def initialize(headers = {})
    @headers = headers
  end

  def call
    api_tokens.include?(headers[API_ACCESS_TOKEN_KEY])
  end

  def api_tokens
    begin
      ENV['API_ACCESS_TOKENS'].split(' ')
    rescue StandardError
      []
    end
  end
end
