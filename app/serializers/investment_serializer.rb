class InvestmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :amount,
             :creator_email,
             :creator_id,
             :campaign_name,
             :campaign_id,
             :created_at,
             :updated_at

  def creator_email
    object.creator.email
  end

  def campaign_name
    object.campaign.name
  end
end
