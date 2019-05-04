class Transaction < ApplicationRecord
  belongs_to :account

  validates :kind, :value, presence: true

  enum kind: %i[debit credit]
end
