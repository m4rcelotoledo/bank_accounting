# frozen_string_literal: true

class User < ApplicationRecord
  has_one :account, dependent: :destroy

  has_secure_password

  validates :cpf, presence: true, uniqueness: true
  validates :name, presence: true
end
