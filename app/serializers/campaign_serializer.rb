class CampaignSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :name,
             :sector,
             :country,
             :image,
             :target_amount,
             :investment_multiple,
             :created_at,
             :updated_at
end
