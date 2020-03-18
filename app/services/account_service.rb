# frozen_string_literal: true

class AccountService
  def self.balance_initial(account_id)
    Transaction.create!(
      account_id: account_id,
      description: 'Initial balance',
      kind: 'initial_balance',
      amount: 0
    )
  end

  def self.sufficient_funds?(account_id, amount)
    Account.find_by(id: account_id).then do |acc|
      acc.current_balance.then do |balance|
        balance.positive? && balance >= amount.to_f
      end
    end
  end
end
