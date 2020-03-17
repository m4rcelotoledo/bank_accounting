# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_account, only: %i[deposit transfer]

  attr_reader :account

  # POST /transactions/deposit
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

  # POST /transactions/transfer
  def transfer
    TransactionService.transfer!(
      params[:account_id],
      params[:destination_account],
      params[:amount]
    )

    json_response 'Transfer successful', :created
  end

  private

  def transaction_params
    params.permit(:account_id, :destination_account, :amount)
  end

  def set_account
    @account = Account.find transaction_params[:account_id]
  end
end
