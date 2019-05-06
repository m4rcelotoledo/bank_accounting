class AccountService
  def self.balance_initial(account_id)
    Transaction.create!(
      account_id: account_id, kind: 'credit', value: 0, balance: 0
    )
  end

  def self.current_balance(account)
    account.transactions.last.balance
  end

  def self.update_balance!(last_balance, transaction)
    if transaction.kind == 'credit'
      transaction.balance = last_balance + transaction.value
    else
      raise InsufficientFunds, 'Transaction canceled' unless
        sufficient_funds?(last_balance, transaction)

      transaction.balance = last_balance - transaction.value
    end

    transaction.save!
  end

  def self.sufficient_funds?(last_balance, transaction)
    last_balance >= transaction.value
  end
end
