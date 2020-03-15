# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccountsController', type: :request do
  describe 'POST /users/:user_id/accounts' do
    let(:user) { create(:user) }
    let(:valid_params) { { user_id: user.id } }

    context 'when the request is invalid' do
      before do
        post '/users/x/accounts',
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
        expect(json).not_to be_empty
      end
    end

    context 'when the request is valid' do
      let(:account) { User.find(user.id).account }

      before do
        post "/users/#{user.id}/accounts",
             params: valid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'creates an account' do
        expect(response).to have_http_status :created
        expect(json).not_to be_empty
        expect(json['id']).to eq account.id
        expect(json['user_id']).to eq user.id
      end
    end

    context 'when the user is unauthorized' do
      before do
        post "/users/#{user.id}/accounts",
             params: valid_params,
             headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET /users/:user_id/accounts/:id' do
    let(:user) { create(:user) }

    context 'when the record exists' do
      let(:account) { create(:account, user: user) }

      before do
        get "/users/#{user.id}/accounts/#{account.id}",
            headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns the account' do
        expect(json).not_to be_empty
        expect(json['id']).to eq account.id
      end

      it 'returns status code 200' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when the record does not exist' do
      before do
        get "/users/#{user.id}/accounts/100",
            headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Account/)
      end
    end
  end

  describe 'GET /balance' do
    context 'when accounts starting with zero balance' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }

      before do
        get '/balance',
            params: { account: account.id },
            headers: basic_credentials(user.cpf, user.password)
      end

      it do
        expect(response).to have_http_status :ok
        expect(json).to eq 0.0
      end
    end
  end
end
