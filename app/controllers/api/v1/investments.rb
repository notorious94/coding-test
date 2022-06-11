# frozen_string_literal: true

module API
  module V1
    class Investments < Grape::API
      include API::V1::Defaults

      desc 'Create an Investment'
      resource :investments do
        params do
          requires :amount, type: BigDecimal
          requires :campaign_id, type: Integer
          requires :creator_id, type: Integer
        end
        post '/' do
          response = nil

          unless params[:amount].positive?
            status(400)
            response = { status: 400, error: 'Invalid investment amount.' }
          end

          campaign = Campaign.find(params[:campaign_id])
          user = User.find(params[:creator_id])

          if response.nil?
            begin
              investment_amount = params[:amount]
              unless (investment_amount.modulo(campaign.investment_multiple)) <= (0.000000000)
                status(400)
                response = { status: 400, error: "Invalid investment amount. Should be a multiple of #{campaign.investment_multiple}" }
              end
            rescue StandardError => e
              status(400)
              response = { status: 400, error: "Invalid investment multiple for Campaign ID: #{campaign.id}" }
            end
          end

          if response.nil?
            response = Investment.create(amount: params[:amount],
                                         creator_id: user.id,
                                         campaign_id: campaign.id)
          end
          response
        end
      end
    end
  end
end
