require 'rails_helper'

RSpec.describe Campaign, type: :model do
  # Association test
  it { should have_many(:investments).dependent(:destroy) }

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:image) }
  it { should validate_presence_of(:target_amount) }
  it { should validate_presence_of(:sector) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:investment_multiple) }
end
