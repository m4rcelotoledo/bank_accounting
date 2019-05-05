class TransactionsController < ApplicationController
  # POST /users/:user_id/accounts/:account_id/transactions
  def create
    @transaction = Transaction.create!(transaction_params)

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
end
