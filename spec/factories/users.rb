FactoryBot.define do
  factory :user do
    cpf { Faker::IDNumber.brazilian_citizen_number }
    name { Faker::Books::Dune.character }
    password_digest { Faker::Internet.password }
  end
end
