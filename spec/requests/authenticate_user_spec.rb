require 'rails_helper'

RSpec.describe 'Authenticate User', type: :request do
  let!(:user) do
    User.create(email: 'user@admin.com',
                password: '123456',
                password_confirmation: '123456',
                jti: SecureRandom.uuid)
  end

  let!(:valid_request_params) do
    {
      'email' => user.email,
      'password' => '123456'
    }
  end

  let!(:request_headers) do
    {
      'Content-Type' => 'application/json',
      'Api-Access-Token' => ENV['API_ACCESS_TOKENS']
    }
  end

  it 'tests valid login' do
    post '/api/v1/auth/authenticate.json', params: valid_request_params, headers: request_headers, as: :json
    expect(response).to have_http_status(:success)
  end

  let!(:invalid_request_params) do
    {
      'email' => user.email,
      'password' => '000000'
    }
  end

  it 'tests invalid login attempt' do
    post '/api/v1/auth/authenticate.json', params: invalid_request_params, headers: request_headers, as: :json
    expect(response).to have_http_status(401)
  end
end
