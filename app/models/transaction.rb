# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :account

  validates :kind, :amount, presence: true

  enum kind: { initial_balance: 0, debit: 1, credit: 2 }
end
