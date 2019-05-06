class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  def current_balance
    transactions.last.balance
  end
end
