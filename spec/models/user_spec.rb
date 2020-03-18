# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  it { is_expected.to have_one(:account).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:cpf) }
  it { is_expected.to validate_uniqueness_of(:cpf) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_length_of(:password).is_at_least(8) }
  it { is_expected.to have_secure_password }
end
