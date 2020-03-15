# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: :show
  attr_reader :account

  # GET /balance
  def balance
    account = Account.find balance_params[:account]
    @balance = account.current_balance

    json_response @balance
  end

  # POST /users/:user_id/accounts
  def create
    @account = Account.create!(account_params)
    AccountService.balance_initial @account.id

    json_response @account, :created
  end

  # GET /users/:user_id/accounts/:id
  def show
    json_response @account
  end

  private

  def account_params
    params.permit(:user_id)
  end

  def balance_params
    params.permit(:account, :user_id)
  end

  def set_account
    @account = Account.find params[:id]
  end
end
