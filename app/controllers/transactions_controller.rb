# frozen_string_literal: true

class TransactionsController < ApplicationController
  # POST /deposit
  def deposit
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
    Transaction.find(params[:id]).then do |transaction|
      json_response transaction
    end
  end

  # POST /transfer
  def transfer
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
