class AccountsController < ApplicationController
  def create
    @account = Account.create!(account_params)

    json_response @account, :created
  end

  private

  def account_params
    params.permit(:user_id)
  end
end
