class Campaign < ApplicationRecord
  has_many :investments, dependent: :destroy
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  validates :name, uniqueness: true, presence: true
  validates :creator_id, :sector, :country, :image, :target_amount, :investment_multiple, presence: true
end
