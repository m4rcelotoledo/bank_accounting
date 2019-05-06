class TransactionsController < ApplicationController
  attr_reader :account
  before_action :set_account, only: :create

  # POST /users/:user_id/accounts/:account_id/transactions
  def create
    last_balance = AccountService.current_balance(account)
    @transaction = Transaction.create!(transaction_params)
    AccountService.update_balance!(last_balance, @transaction)

    json_response @transaction, :created
  end

  # GET /users/:user_id/accounts/:account_id/transactions/:id
  def show
    @transaction = Transaction.find(params[:id])

    json_response @transaction
  end

  private

  def transaction_params
    params.permit(:account_id, :kind, :value)
  end

  def set_account
    @account = Account.find transaction_params[:account_id]
  end
end
