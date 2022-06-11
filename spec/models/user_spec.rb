require 'rails_helper'

# Test suite for User model
RSpec.describe User, type: :model do
  # Association test
  it { should have_many(:investments) }
  it { should have_many(:campaigns) }

  # Validation tests
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:encrypted_password) }
  it { should validate_presence_of(:jti) }
end
