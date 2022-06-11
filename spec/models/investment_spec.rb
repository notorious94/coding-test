require 'rails_helper'

RSpec.describe Investment, type: :model do
  # Association test
  it { should belong_to(:campaign) }
  it { should belong_to(:creator) }

  # Validation tests
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:creator_id) }
end
