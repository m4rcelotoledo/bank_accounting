class TransactionsController < ApplicationController
  before_action :set_account, only: :create
  attr_reader :account

  # POST /users/:user_id/accounts/:account_id/transactions
  def create
    balance = account.current_balance

    ActiveRecord::Base.transaction do
      @transaction = Transaction.create!(transaction_params)
      AccountService.update_balance!(balance, @transaction)
    end

    json_response @transaction, :created
  end

  # GET /users/:user_id/accounts/:account_id/transactions/:id
  def show
    @transaction = Transaction.find(params[:id])

    json_response @transaction
  end

  def transfer
    AccountService.transfer!(params[:source_account],
                             params[:destination_account], params[:amount])

    json_response 'Transfer successful', :created
  end

  private

  def transaction_params
    params.permit(:account_id, :kind, :value)
  end

  def set_account
    @account = Account.find transaction_params[:account_id]
  end
end
