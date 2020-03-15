# frozen_string_literal: true

class AccountService
  def self.balance_initial(account_id)
    Transaction.create!(
      account_id: account_id, kind: 'initial_balance', value: 0
    )
  end

  def self.update_balance!(balance, transaction)
    ActiveRecord::Base.transaction do
      if transaction.kind == 'credit'
        transaction.balance = balance + transaction.value
      else
        raise InsufficientFunds, 'Transaction canceled' unless
          sufficient_funds?(balance, transaction.value)

        transaction.balance = balance - transaction.value
      end

      transaction.save!
    end
  end

  def self.transfer!(source, destination, amount)
    ActiveRecord::Base.transaction do
      source_acc = Account.find(source).current_balance
      dest_acc = Account.find(destination).current_balance

      source = create_transaction(source, 'debit', amount)
      update_balance!(source_acc, source)

      destination = create_transaction(destination, 'credit', amount)
      update_balance!(dest_acc, destination)
    end
  end

  class << self
    private

    def sufficient_funds?(balance, amount)
      balance.positive? && balance >= amount
    end

    def create_transaction(account, kind, amount)
      Transaction.create!(account_id: account, kind: kind, value: amount)
    end
  end
end
