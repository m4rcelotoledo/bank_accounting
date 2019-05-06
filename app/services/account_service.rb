class AccountService
  def self.balance_initial(account_id)
    Transaction.create!(
      account_id: account_id, kind: 'credit', value: 0, balance: 0
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

  def self.sufficient_funds?(last_balance, transaction)
    last_balance >= transaction.value
  end
end
