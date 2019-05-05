class AccountsController < ApplicationController
  def create
    @account = Account.create!(account_params)
    AccountService.balance_initial @account.id

    json_response @account, :created
  end

  # GET /users/:user_id/accounts/:id
  def show
    @account = Account.find(params[:id])

    json_response @account
  end

  private

  def account_params
    params.permit(:account_id, :user_id)
  end
end
