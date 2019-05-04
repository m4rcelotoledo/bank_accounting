FactoryBot.define do
  factory :transaction do
    account
    kind { 1 }
    value { Faker::Commerce.price(10..100.0, as_string: true) }
    balance { Faker::Commerce.price(10..1000.0, as_string: true) }
  end
end
