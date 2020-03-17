# frozen_string_literal: true

class AccountService
  def self.balance_initial(account_id)
    Transaction.create!(
      account_id: account_id, kind: 'initial_balance', amount: 0
    )
  end

  def self.sufficient_funds?(account, amount)
    account.current_balance.then do |balance|
      balance.positive? && balance >= amount.to_f
    end
  end
end
