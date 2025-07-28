# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :validate_balance_params?, only: [:balance]
  before_action :validate_statement_params?, only: [:statement]
  before_action :check_user_exists_before_create?, only: [:create]

  # GET /accounts/:id
  def show
    Account.includes(:user, :transactions).find(params[:id]).then do |account|
      json_response account
    end
  end

  # GET /balance
  def balance
    return if validate_account_exists?(account_params[:account_id])

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
    return if validate_account_exists?(account_params[:account_id])

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

  def validate_balance_params?
    validate_presence_of_required_params?(%i[account_id], :account)
  end

  def validate_statement_params?
    validate_presence_of_required_params?(%i[account_id], :account)
  end

  def check_user_exists_before_create?
    return false unless account_params

    validate_user_exists?(account_params[:user_id])
  end
end
