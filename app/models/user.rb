class User < ApplicationRecord
  has_many :investments, class_name: 'Investment', foreign_key: :creator_id, dependent: :destroy
  has_many :campaigns, class_name: 'Campaign', foreign_key: :creator_id, dependent: :destroy
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  before_create :add_jti

  def add_jti
    self.jti ||= SecureRandom.uuid
  end

  def jwt_payload
    super.merge('expires_at' => (Time.now + 1.day))
  end

  validates :email, :encrypted_password, :jti, presence: true

end
