# frozen_string_literal: true

require 'rails_helper'

describe Transaction, type: :model do
  subject(:transaction) { described_class.new }

  it { is_expected.to belong_to(:account) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_presence_of(:amount) }

  it do
    expect(transaction).to define_enum_for(:kind).
      with_values(initial_balance: 0, debit: 1, credit: 2)
  end
end
