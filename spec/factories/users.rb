# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    cpf { Faker::IdNumber.brazilian_citizen_number }
    name { Faker::Books::Dune.character }
    password { Faker::Internet.password }
  end
end
