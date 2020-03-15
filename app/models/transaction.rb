# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :account

  validates :kind, :value, presence: true

  enum kind: { debit: 0, credit: 1 }
end
