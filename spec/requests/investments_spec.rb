require 'rails_helper'

RSpec.describe 'Investments API', type: :request do
  let!(:user) do
    User.create(email: 'user@admin.com',
                password: '123456',
                password_confirmation: '123456',
                jti: SecureRandom.uuid)
  end

  let!(:headers) do
    {
      'Content-Type' => 'application/json'
    }
  end

  let!(:campaign) do
    Campaign.create(name: Faker::Company.unique.name,
                    image: 'https://drive.goog le.com/file/d/1ySv3C9gzvcdG0PfqJVmNx68aLsCVYoNv/view?usp=sharing',
                    sector: Faker::Job.field,
                    country: Faker::Address.country,
                    creator_id: user.id,
                    target_amount: Faker::Number.decimal(l_digits: 10, r_digits: 2),
                    investment_multiple: Faker::Number.decimal(l_digits: 2, r_digits: 2))
  end

  let(:request_params) do
    {
      'amount' => Campaign.first.investment_multiple,
      'campaign_id' => Campaign.first.id,
      'creator_id' => user.id
    }
  end

  let(:request_params_with_invalid_campaign) do
    {
      'amount' => 10,
      'campaign_id' => 0,
      'creator_id' => user.id
    }
  end

  it 'creates investment with valid data' do
    post '/api/v1/investments', params: request_params, headers: headers, as: :json
    expect(response).to have_http_status(:success)
  end

  it 'creates investment with an invalid campaign ID' do
    post '/api/v1/investments', params: request_params_with_invalid_campaign, headers: headers, as: :json
    expect(response).to have_http_status(404)
  end

  let(:request_params_with_invalid_user) do
    {
      'amount' => campaign.investment_multiple,
      'campaign_id' => Campaign.first.id,
      'creator_id' => 0
    }
  end

  it 'creates investment with an invalid user ID' do
    post '/api/v1/investments', params: request_params_with_invalid_user, headers: headers, as: :json
    expect(response).to have_http_status(404)
  end

  let(:request_params_with_zero_amount) do
    {
      'amount' => 0.0,
      'campaign_id' => Campaign.first.id,
      'creator_id' => user.id
    }
  end

  it 'creates investment with zero amount' do
    post '/api/v1/investments', params: request_params_with_zero_amount, headers: headers, as: :json
    expect(response).to have_http_status(400)
  end

  let(:request_params_with_negative_amount) do
    {
      'amount' => -5.26,
      'campaign_id' => campaign.id,
      'creator_id' => user.id
    }
  end

  it 'creates investment with negative amount' do
    post '/api/v1/investments', params: request_params_with_negative_amount, headers: headers, as: :json
    expect(response).to have_http_status(400)
  end

  let(:request_params_with_invalid_investment_amount) do
    {
      'amount' => Campaign.first.investment_multiple + 5.26,
      'campaign_id' => campaign.id,
      'creator_id' => user.id
    }
  end

  it 'creates investment with an invalid amount' do
    post '/api/v1/investments', params: request_params_with_invalid_investment_amount, headers: headers, as: :json
    expect(response).to have_http_status(400)
  end
end
