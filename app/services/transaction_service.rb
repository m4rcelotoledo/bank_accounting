# frozen_string_literal: true

class TransactionService
  def self.deposit(account, amount)
    Transaction.create!(
      account_id: account,
      kind: 'credit',
      amount: amount,
      description: 'Deposit'
    )
  end

  def self.transfer!(source, destination, amount)
    ActiveRecord::Base.transaction do
      valid_account?(destination)

      raise InsufficientFunds, 'Transaction canceled' unless AccountService.sufficient_funds?(source, amount)

      transfer_to(source, amount, destination)
      transfer_from(destination, amount, source)
    end
  end

  class << self
    private

    def transfer_to(account, amount, destination)
      Transaction.create!(
        account_id: account, kind: 'debit',
        amount: -1 * amount.to_f,
        description: "Transfer to account #{destination}"
      )
    end

    def transfer_from(account, amount, source)
      Transaction.create!(
        account_id: account, kind: 'credit',
        amount: amount,
        description: "Transfer from account #{source}"
      )
    end

    def valid_account?(destination)
      Account.find(destination)
    end
  end
end
