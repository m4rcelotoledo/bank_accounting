# frozen_string_literal: true

require 'rails_helper'

describe 'TransactionsController', type: :request do
  describe 'POST /users/:user_id/accounts/:account_id/transactions' do
    context 'when the user is unauthorized' do
      before do
        post '/users/1/accounts',
             headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the request is invalid' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }
      let(:invalid_params) do
        {
          user_id: user.id,
          account_id: account.id
        }
      end

      before do
        post "/users/#{user.id}/accounts/#{account.id}/transactions",
             params: invalid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
        expect(json).not_to be_empty
      end
    end

    context 'when the transaction is of kind debit' do
      context 'with the request is valid' do
        subject(:post_transaction) do
          post "/users/#{user.id}/accounts/#{account.id}/transactions",
               params: valid_params,
               headers: basic_credentials(user.cpf, user.password)
        end

        let(:user) { create(:user) }
        let(:account) { create(:account_with_transaction, user: user) }
        let(:kind) { 'debit' }
        let(:value) { Faker::Commerce.price(range: 50..100.0, as_string: true) }
        let(:valid_params) do
          {
            user_id: user.id,
            account_id: account.id,
            kind: kind,
            value: value
          }
        end

        context 'with balance is not enough' do
          it 'transaction is canceled' do
            expect { post_transaction }.
              to raise_exception InsufficientFunds, 'Transaction canceled'
            account.reload
            expect(account.current_balance).to eq 0
          end
        end

        context 'with creates a transaction' do
          before do
            transaction = account.transactions.last
            transaction.balance = 500.0
            transaction.save!
            post_transaction
          end

          it 'balance is updated' do
            expect(response).to have_http_status :created
            expect(json).not_to be_empty
            expect(json['kind']).to eq kind
            expect(formatted_currency(json['value'])).
              to eq formatted_currency(value)
            expect(formatted_currency(json['balance'])).
              to eq formatted_currency(500.0 - value.to_f)
          end
        end
      end
    end

    context 'when the transaction is of kind credit' do
      context 'with the request is valid' do
        let(:user) { create(:user) }
        let(:account) { create(:account_with_transaction, user: user) }
        let(:kind) { 'credit' }
        let(:value) { Faker::Commerce.price(range: 50..100.0, as_string: true) }
        let(:valid_params) do
          {
            user_id: user.id,
            account_id: account.id,
            kind: kind,
            value: value
          }
        end

        before do
          post "/users/#{user.id}/accounts/#{account.id}/transactions",
               params: valid_params,
               headers: basic_credentials(user.cpf, user.password)
        end

        it 'creates a transaction' do
          expect(response).to have_http_status :created
          expect(json).not_to be_empty
          expect(json['kind']).to eq kind
          expect(formatted_currency(json['value'])).
            to eq formatted_currency(value)
        end
      end

      context 'with the transaction is created' do
        let(:user) { create(:user) }
        let(:account) { create(:account_with_transaction, user: user) }
        let(:kind) { 'credit' }
        let(:value) { Faker::Commerce.price(range: 50..100.0, as_string: true) }
        let(:valid_params) do
          {
            user_id: user.id,
            account_id: account.id,
            kind: kind,
            value: value
          }
        end

        before do
          post "/users/#{user.id}/accounts/#{account.id}/transactions",
               params: valid_params,
               headers: basic_credentials(user.cpf, user.password)
        end

        it 'balance is updated' do
          expect(response).to have_http_status :created
          expect(json['kind']).to eq kind
          expect(formatted_currency(json['value'])).
            to eq formatted_currency(value)
          expect(formatted_currency(json['balance'])).
            to eq formatted_currency(value)
        end
      end
    end
  end

  describe 'POST /transfer' do
    context 'when the user is unauthorized' do
      before do
        post '/transfer',
             headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the source account is not found' do
      let(:user) { create(:user) }
      let(:destination_account) do
        create(:account_with_transaction, user: user)
      end
      let(:amount) { Faker::Commerce.price(range: 50..100.0, as_string: true) }
      let(:invalid_params) do
        {
          user_id: user.id,
          source_account: 9999,
          destination_account: destination_account.id,
          amount: amount
        }
      end

      before do
        post '/transfer',
             params: invalid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns the account is not found' do
        expect(response).to have_http_status :not_found
      end
    end

    context 'when the destination account is not found' do
      let(:user) { create(:user) }
      let(:source_account) { create(:account_with_transaction, user: user) }
      let(:amount) { Faker::Commerce.price(range: 50..100.0, as_string: true) }
      let(:invalid_params) do
        {
          user_id: user.id,
          source_account: source_account.id,
          destination_account: 9999,
          amount: amount
        }
      end

      before do
        post '/transfer',
             params: invalid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns the account is not found' do
        expect(response).to have_http_status :not_found
      end
    end

    context 'when the balance from source account is not enough' do
      subject(:post_transfer) do
        post '/transfer',
             params: valid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      let(:user) { create(:user) }
      let(:another_user) { create(:user) }
      let(:source_account) do
        create(:account_with_transaction, user: user)
      end
      let(:destination_account) do
        create(:account_with_transaction, user: another_user)
      end
      let(:amount) { Faker::Commerce.price(range: 50..100.0, as_string: true) }
      let(:valid_params) do
        {
          user_id: user.id,
          source_account: source_account.id,
          destination_account: destination_account.id,
          amount: amount
        }
      end

      it 'transaction is canceled' do
        expect { post_transfer }.
          to raise_exception InsufficientFunds, 'Transaction canceled'
        source_account.reload
        destination_account.reload
        expect(source_account.current_balance).to eq 0
        expect(destination_account.current_balance).to eq 0
      end
    end

    context 'when the request is valid' do
      let(:user) { create(:user) }
      let(:another_user) { create(:user) }
      let(:source_account) do
        create(:account_with_transaction, user: user)
      end
      let(:destination_account) do
        create(:account_with_transaction, user: another_user)
      end
      let(:amount) { Faker::Commerce.price(range: 50..100.0, as_string: true) }
      let(:valid_params) do
        {
          user_id: user.id,
          source_account: source_account.id,
          destination_account: destination_account.id,
          amount: amount
        }
      end

      before do
        transaction = source_account.transactions.last
        transaction.balance = 500.0
        transaction.save!
        post '/transfer',
             params: valid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'transfer is successful' do
        source_account.reload
        destination_account.reload
        expect(response).to have_http_status :created
        expect(response.body).to eq 'Transfer successful'
        expect(formatted_currency(source_account.current_balance)).
          to eq formatted_currency(500 - amount.to_f)
        expect(formatted_currency(destination_account.current_balance)).
          to eq formatted_currency(amount.to_f)
      end
    end
  end

  describe 'GET /users/:user_id/accounts/:account_id/transactions/:id' do
    context 'when the user is unauthorized' do
      let(:user) { create(:user) }
      let(:account) { create(:account, user: user) }
      let(:transaction) { create(:transaction, account: account) }
      let(:id) { transaction.id }

      before do
        get "/users/#{user.id}/accounts/#{account.id}/transactions/#{id}",
            headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the account is not found' do
      let(:user) { create(:user) }

      before do
        get "/users/#{user.id}/accounts/500/transactions/500",
            headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
        expect(json).not_to be_empty
      end
    end

    context 'when the transaction is not found' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }

      before do
        get "/users/#{user.id}/accounts/#{account.id}/transactions/500",
            headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
        expect(json).not_to be_empty
      end
    end

    context 'when the request is valid' do
      let(:user) { create(:user) }
      let(:account) { create(:account, user: user) }
      let(:transaction) { create(:transaction, account: account) }
      let(:id) { transaction.id }
      let(:kind) { transaction.kind }
      let(:value) { transaction.value }

      before do
        get "/users/#{user.id}/accounts/#{account.id}/transactions/#{id}",
            headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns the transaction' do
        expect(response).to have_http_status :ok
        expect(json).not_to be_empty
        expect(json['kind']).to eq kind
        expect(formatted_currency(json['value'])).
          to eq formatted_currency(value)
      end
    end
  end
end
