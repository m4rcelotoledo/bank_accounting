require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should belong_to(:account) }
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:value) }
  it { should define_enum_for(:kind) }
end
