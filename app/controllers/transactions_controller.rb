class TransactionsController < ApplicationController
  # POST /users/:user_id/accounts/:account_id/transactions
  def create
    @transaction = Transaction.create!(transaction_params)

    json_response @transaction, :created
  end

  private

  def transaction_params
    params.permit(:account_id, :kind, :value)
  end
end
