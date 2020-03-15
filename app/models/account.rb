# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  def current_balance
    transactions.sum(&:value)
  end
end
