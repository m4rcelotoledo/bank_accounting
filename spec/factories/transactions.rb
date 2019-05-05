FactoryBot.define do
  factory :transaction do
    account
    kind { 'credit' }
    value { Faker::Commerce.price(10..100.0, as_string: true) }
    balance { Faker::Commerce.price(10..1000.0, as_string: true) }
  end
end
