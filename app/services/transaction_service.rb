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
      Account.find(destination)
      source_acc = Account.find(source)

      unless AccountService.sufficient_funds?(source_acc, amount)
        raise InsufficientFunds, 'Transaction canceled'
      end

      transfer_to(source, 'debit', amount, destination)
      transfer_from(destination, 'credit', amount, source)
    end
  end

  class << self
    private

    def transfer_to(account, kind, amount, destination)
      Transaction.create!(
        account_id: account, kind: kind,
        amount: -1 * amount.to_f,
        description: "Transfer to account #{destination}"
      )
    end

    def transfer_from(account, kind, amount, source)
      Transaction.create!(
        account_id: account, kind: kind,
        amount: amount,
        description: "Transfer from account #{source}"
      )
    end
  end
end
