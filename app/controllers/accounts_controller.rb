# frozen_string_literal: true

class AccountsController < ApplicationController
  # GET /accounts/:id
  def show
    Account.includes(:user, :transactions).find(params[:id]).then do |account|
      json_response account
    end
  end

  # GET /balance
  def balance
    Account.includes(:transactions).find(account_params[:account_id]).then do |account|
      account.current_balance.then { |balance| json_response({ balance: balance }) }
    end
  end

  # POST /accounts
  def create
    Account.create!(account_params).then do |account|
      AccountService.balance_initial account.id
      json_response account, :created
    end
  end

  # GET /statement
  def statement
    Account.includes(:transactions).find(account_params[:account_id]).then do |account|
      account.transactions.then do |transactions|
        render json: transactions, status: :ok,
               each_serializer: TransactionSerializer
      end
    end
  end

  private

  def account_params
    params.expect(account: %i[user_id account_id])
  end
end
