require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_one(:account).dependent(:destroy) }
  it { should validate_presence_of(:cpf) }
  it { should validate_uniqueness_of(:cpf) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:password) }
  it { should have_secure_password }
end
