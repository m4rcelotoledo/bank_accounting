class AccountsController < ApplicationController
  def create
    @account = Account.create!(account_params)

    json_response @account, :created
  end

  # GET /users/:user_id/accounts/:id
  def show
    @account = Account.find(params[:id])

    json_response @account
  end

  private

  def account_params
    params.permit(:user_id)
  end
end
