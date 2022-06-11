require 'rails_helper'

RSpec.describe 'Campaigns API', type: :request do
  let!(:user) do
    User.create(email: 'user@admin.com',
                password: '123456',
                password_confirmation: '123456',
                jti: SecureRandom.uuid)
  end

  let!(:headers) do
    {
      'Authorization' => "Bearer #{AuthenticateUser.new(user.email, '123456').call}",
      'Api-Access-Token' => ENV['API_ACCESS_TOKENS'],
      'Content-Type' => 'application/json'
    }
  end

  it 'checks without campaign data' do
    Campaign.destroy_all
    get '/api/v1/campaigns', params: {}, headers: headers
    expect(JSON.parse(response.body).size).to eq(0)
  end

  it 'returns status code 200' do
    get '/api/v1/campaigns', params: {}, headers: headers
    expect(response).to have_http_status(:success)
  end

  let!(:campaigns) do
    100.times do
      Campaign.create(name: Faker::Company.unique.name,
                      image: 'https://drive.google.com/file/d/1ySv3C9gzvcdG0PfqJVmNx68aLsCVYoNv/view?usp=sharing',
                      sector: Faker::Job.field,
                      country: Faker::Address.country,
                      creator_id: user.id,
                      target_amount: Faker::Number.decimal(l_digits: 10, r_digits: 2),
                      investment_multiple: Faker::Number.decimal(l_digits: 2, r_digits: 2))
    end
  end

  it 'checks with data' do
    get '/api/v1/campaigns', params: {}, headers: headers
    expect(JSON.parse(response.body).size).to eq(10)
  end

  it 'checks pagination' do
    get '/api/v1/campaigns', params: { page_no: 2 }, headers: headers
    expect(JSON.parse(response.body).size).to eq(10)
  end

  it 'checks pagination with custom params' do
    get '/api/v1/campaigns', params: { per_page: 20 }, headers: headers
    expect(JSON.parse(response.body).size).to eq(20)
  end

  let(:expired_token_headers) do
    expired_token = JsonWebToken.encode(user_id: user.id, exp: (Time.now - 10.days).to_i)
    {
      'Authorization' => "Bearer #{expired_token}",
      'Api-Access-Token' => ENV['API_ACCESS_TOKENS'],
      'Content-Type' => 'application/json'
    }
  end

  it 'raises an expired token error' do
    get '/api/v1/campaigns', params: { per_page: 20 }, headers: expired_token_headers
    expect(response).to have_http_status(:unauthorized)
    expect(JSON.parse(response.body)['error_code']).to eq(2002)
  end

  let(:headers_with_invalid_api_token) do
    {
      'Authorization' => "Bearer #{AuthenticateUser.new(user.email, '123456').call}",
      'Api-Access-Token' => '#####################',
      'Content-Type' => 'application/json'
    }
  end

  it 'raises an invalid API token error' do
    get '/api/v1/campaigns', params: { per_page: 20 }, headers: headers_with_invalid_api_token
    expect(JSON.parse(response.body)['error_code']).to eq(4020)
    expect(response).to have_http_status(:unauthorized)
  end

end
