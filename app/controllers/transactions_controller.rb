# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :set_account, only: %i[deposit transfer]
  before_action :validate_deposit_params, only: [:deposit]
  before_action :validate_transfer_params, only: [:transfer]

  attr_reader :account

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
      params[:account_id],
      params[:destination_account],
      params[:amount]
    )

    render json: { message: 'Transfer successful' }, status: :created
  end

  private

  def transaction_params
    params.permit(:account_id, :destination_account, :amount)
  end

  def set_account
    @account = Account.find transaction_params[:account_id]
  end

  def validate_deposit_params
    validate_presence_of_required_params(%i[account_id amount])
  end

  def validate_transfer_params
    validate_presence_of_required_params(%i[account_id destination_account amount])
  end
end
