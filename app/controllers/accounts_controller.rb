# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: %i[show]
  before_action :validate_balance_params, only: [:balance]
  before_action :validate_statement_params, only: [:statement]

  attr_reader :account

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

  # GET /accounts/:id
  def show
    json_response @account
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
    params.permit(:user_id, :account_id)
  end

  def set_account
    @account = Account.includes(:user, :transactions).find params[:id]
  end

  def validate_balance_params
    validate_presence_of_required_params(%i[account_id])
  end

  def validate_statement_params
    validate_presence_of_required_params(%i[account_id])
  end
end
