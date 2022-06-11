class Investment < ApplicationRecord
  belongs_to :campaign
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  validates :creator_id, :campaign_id, :amount, presence: true
end
