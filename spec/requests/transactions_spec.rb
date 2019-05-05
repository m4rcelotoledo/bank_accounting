require 'rails_helper'

RSpec.describe 'TransactionsController', type: :request do
  describe 'POST /users/:user_id/accounts/:account_id/transactions' do
    context 'when the user is unauthorized' do
      let(:user) { create(:user) }
      let(:account) { create(:account, user: user) }
      let(:kind) { 'debit' }
      let(:value) { Faker::Commerce.price(50..100.0, as_string: true) }
      let(:valid_params) do
        {
          user_id: user.id,
          account_id: account.id,
          kind: kind,
          value: value
        }
      end

      before do
        post "/users/#{user.id}/accounts",
             params: valid_params,
             headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the request is invalid' do
      let(:user) { create(:user) }

      before do
        post "/users/#{user.id}/accounts/xxxx/transactions",
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
        expect(json).not_to be_empty
      end
    end

    context 'when the transaction is of kind debit' do
      let(:user) { create(:user) }
      let(:account) { create(:account, user: user) }

      context 'when the request is valid' do
        let(:kind) { 'debit' }
        let(:value) { Faker::Commerce.price(50..100.0, as_string: true) }
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
    end

    context 'when the transaction is of kind credit' do
      let(:user) { create(:user) }
      let(:account) { create(:account, user: user) }

      context 'when the request is valid' do
        let(:kind) { 'credit' }
        let(:value) { Faker::Commerce.price(50..100.0, as_string: true) }
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

    context 'when the request is invalid' do
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
