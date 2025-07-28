# frozen_string_literal: true

module Validations
  extend ActiveSupport::Concern

  private

  def validate_account_exists?(account_id)
    unless Account.exists?(id: account_id)
      render_not_found("Couldn't find Account with 'id'=#{account_id}")
      return true
    end
    false
  end

  def validate_user_exists?(user_id)
    unless User.exists?(id: user_id)
      render_unprocessable_entity('User not found')
      return true
    end
    false
  end

  def validate_transaction_exists?(transaction_id)
    unless Transaction.exists?(id: transaction_id)
      render_not_found('Transaction not found')
      return true
    end
    false
  end

  def validate_amount_positive?(amount)
    return false if amount.nil? || amount.to_s.strip.empty?

    amount_float = amount.to_f

    unless amount_float.positive?
      render_unprocessable_entity('Amount must be positive')
      return true
    end
    false
  end

  def validate_presence_of_required_params?(required_params, param_key = :account)
    param_hash = params[param_key] || {}
    missing_params = required_params.select { |param| param_hash[param].blank? }

    return false if missing_params.empty?

    render_missing_parameters(missing_params)
    true
  end
end
