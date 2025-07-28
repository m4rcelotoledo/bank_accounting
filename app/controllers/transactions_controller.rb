# frozen_string_literal: true

class TransactionsController < ApplicationController
  # POST /deposit
  def deposit
    return if validate_presence_of_required_params?(%i[account_id amount], :transaction)
    return if validate_account_exists?(transaction_params[:account_id])
    return if validate_amount_positive?(transaction_params[:amount])

    TransactionService.deposit(
      transaction_params[:account_id],
      transaction_params[:amount]
    ).then do |transaction|
      render json: transaction,
             status: :created,
             serializer: TransactionSerializer
    end
  end

  # GET /transactions/:id
  def show
    return if validate_transaction_exists?(params[:id])

    Transaction.find(params[:id]).then do |transaction|
      json_response transaction
    end
  end

  # POST /transfer
  def transfer
    return if validate_presence_of_required_params?(%i[account_id destination_account amount], :transaction)
    return if validate_account_exists?(transaction_params[:account_id])
    return if validate_account_exists?(transaction_params[:destination_account])
    return if validate_amount_positive?(transaction_params[:amount])

    TransactionService.transfer!(
      transaction_params[:account_id],
      transaction_params[:destination_account],
      transaction_params[:amount]
    )

    render json: { message: 'Transfer successful' }, status: :created
  end

  private

  def transaction_params
    params.expect(transaction: %i[account_id destination_account amount])
  end
end
