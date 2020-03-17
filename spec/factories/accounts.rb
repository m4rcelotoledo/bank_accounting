# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    user

    factory :account_with_transaction do
      after(:create) do |account|
        create(:transaction, account: account,
                             kind: 'initial_balance',
                             description: 'Initial Balance',
                             amount: 0)
      end
    end
  end
end
