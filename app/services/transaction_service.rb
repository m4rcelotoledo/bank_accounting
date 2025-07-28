# frozen_string_literal: true

class TransactionService
  class << self
    def deposit(account_id, amount)
      validate_deposit_params(account_id, amount)

      create_transaction(
        account_id: account_id,
        amount: amount,
        kind: 'credit',
        description: 'Deposit'
      )
    end

    def transfer!(source_account_id, destination_account_id, amount)
      validate_transfer_params(source_account_id, destination_account_id, amount)

      # Validate accounts exist before checking funds
      validate_account_exists(source_account_id)
      validate_account_exists(destination_account_id)

      validate_sufficient_funds(source_account_id, amount)

      ActiveRecord::Base.transaction do
        create_transfer_transactions(source_account_id, destination_account_id, amount)
      end
    end

    private

    def validate_deposit_params(account_id, amount)
      missing_params = []
      missing_params << 'account_id' if account_id.blank?
      missing_params << 'amount' if amount.blank?

      raise ArgumentError, "Missing required parameters: #{missing_params.join(', ')}" if missing_params.any?

      raise ArgumentError, 'Amount must be positive' unless amount.to_f.positive?
    end

    def create_transaction(attributes)
      # Validate account exists before creating transaction
      unless Account.exists?(id: attributes[:account_id])
        raise ActiveRecord::RecordNotFound, "Couldn't find Account with 'id'=#{attributes[:account_id]}"
      end

      Transaction.create!(attributes)
    end

    def validate_transfer_params(source_account_id, destination_account_id, amount)
      missing_params = []
      missing_params << 'account_id' if source_account_id.blank?
      missing_params << 'destination_account' if destination_account_id.blank?
      missing_params << 'amount' if amount.blank?

      raise ArgumentError, "Missing required parameters: #{missing_params.join(', ')}" if missing_params.any?

      if source_account_id == destination_account_id
        raise ArgumentError, 'Source and destination accounts must be different'
      end

      raise ArgumentError, 'Amount must be positive' unless amount.to_f.positive?
    end

    def validate_account_exists(account_id)
      return if Account.exists?(id: account_id)

      raise ActiveRecord::RecordNotFound, "Couldn't find Account with 'id'=#{account_id}"
    end

    def validate_sufficient_funds(account_id, amount)
      raise InsufficientFunds, 'Transaction canceled' unless AccountService.sufficient_funds?(account_id, amount)
    end

    def create_transfer_transactions(source_account_id, destination_account_id, amount)
      # Debit from source account
      create_transaction(
        account_id: source_account_id,
        amount: -amount.to_f,
        kind: 'debit',
        description: "Transfer to account #{destination_account_id}"
      )

      # Credit to destination account
      create_transaction(
        account_id: destination_account_id,
        amount: amount.to_f,
        kind: 'credit',
        description: "Transfer from account #{source_account_id}"
      )
    end
  end
end
