# frozen_string_literal: true

module API
  module V1
    class Campaigns < Grape::API
      include API::V1::Defaults
      include API::V1::Authentication

      resource :campaigns do
        desc 'Return all Campaigns'
        params do
          optional :page_no, type: Integer, default: 1
          optional :per_page, type: Integer, default: 10
          optional :search, type: String, default: ''
        end
        get '/', serializer: CampaignSerializer do
          check_authentication
          attributes = []
          Campaign.attribute_names.excluding('id').each do |attribute|
            attributes << "#{attribute} Like :search"
          end
          Campaign.where(attributes.join(' OR '), search: "%#{params[:search]}%")
                  .paginate(page: params[:page_no], per_page: params[:per_page])
        end
      end
    end
  end
end
