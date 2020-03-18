# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    account
    kind { 'credit' }
    description { 'Deposit' }
    amount { Faker::Commerce.price(range: 10..100.0, as_string: true) }
  end
end
