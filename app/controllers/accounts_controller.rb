# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: %i[show]

  attr_reader :account

  # GET /balance
  def balance
    Account.find(account_params[:account_id]).then do |account|
      account.current_balance.then { |balance| json_response balance }
    end
  end

  # POST /accounts
  def create
    Account.create!(account_params).then do |account|
      AccountService.balance_initial account.id
      json_response account, :created
    end
  end

  # GET /accounts/:id
  def show
    json_response @account
  end

  # GET /statement
  def statement
    Account.find(account_params[:account_id]).then do |account|
      account.transactions.then do |transactions|
        render json: transactions, status: :ok,
               each_serializer: TransactionSerializer
      end
    end
  end

  private

  def account_params
    params.permit(:user_id, :account_id)
  end

  def set_account
    @account = Account.find params[:id]
  end
end
