# frozen_string_literal: true

require 'rails_helper'

describe 'TransactionsController', type: :request do
  describe 'POST /deposit' do
    context 'when the user is unauthorized' do
      before do
        post deposit_path,
             headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
        expect(json[:errors].first[:status]).to eq '401'
        expect(json[:errors].first[:title]).to eq 'Unauthorized'
      end
    end

    context 'when required parameters are missing' do
      let(:user) { create(:user) }
      let(:params) { { account_id: 1 } } # missing amount

      before do
        post deposit_path,
             params: params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
        expect(json[:errors].first[:detail]).to eq 'Missing required parameters: amount'
      end
    end

    context 'when the request is invalid' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }
      let(:invalid_params) { { account_id: account.id } }

      before do
        post deposit_path,
             params: invalid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
        expect(json[:errors].first[:status]).to eq '422'
        expect(json[:errors].first[:title]).to eq 'Unprocessable Entity'
      end
    end

    context 'when amount is invalid' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }

      [
        { amount: 0, description: 'zero' },
        { amount: -100, description: 'negative' }
      ].each do |test_case|
        context "when amount is #{test_case[:description]}" do
          let(:params) { { account_id: account.id, amount: test_case[:amount] } }

          before do
            post deposit_path,
                 params: params,
                 headers: basic_credentials(user.cpf, user.password)
          end

          it 'returns status code 422' do
            expect(response).to have_http_status :unprocessable_entity
            expect(json[:errors].first[:detail]).to eq 'Amount must be positive'
          end
        end
      end
    end

    context 'when the account is not found' do
      let(:user) { create(:user) }
      let(:params) { { account_id: 999, amount: 100 } }

      before do
        post deposit_path,
             params: params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
        expect(json[:errors].first[:detail]).to eq "Couldn't find Account with 'id'=999"
      end
    end

    context 'when the request is valid' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }

      let(:amount) do
        Faker::Commerce.price(range: 50..100.0, as_string: true)
      end

      let(:valid_params) do
        {
          account_id: account.id,
          amount: amount
        }
      end

      before do
        post deposit_path,
             params: valid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'creates a transaction' do
        expect(response).to have_http_status :created
        expect(json).not_to be_empty
        expect(json[:kind]).to eq 'credit'
        expect(formatted_currency(account.current_balance)).to eq amount
      end
    end

    context 'when the account has two transactions' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }
      let(:document) { "##{account.id}##{account.transactions.last.id}" }
      let(:new_transaction) { create(:transaction, account: account) }

      let(:amount) do
        Faker::Commerce.price(range: 50..100.0, as_string: true)
      end

      let(:expected_balance) do
        formatted_currency(new_transaction.amount + amount.to_f)
      end

      let(:valid_params) do
        {
          account_id: account.id,
          amount: amount
        }
      end

      before do
        new_transaction
        post deposit_path,
             params: valid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'balance is updated' do
        expect(response).to have_http_status :created
        expect(json[:document]).to eq document
        expect(json[:description]).to eq 'Deposit'
        expect(json[:kind]).to eq 'credit'
        expect(expected_balance).
          to eq formatted_currency(account.current_balance)
      end
    end
  end

  describe 'POST /transfer' do
    context 'when the user is unauthorized' do
      before do
        post transfer_path,
             headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
        expect(json[:errors].first[:status]).to eq '401'
        expect(json[:errors].first[:title]).to eq 'Unauthorized'
      end
    end

    context 'when required parameters are missing' do
      let(:user) { create(:user) }
      let(:params) { { account_id: 1 } } # missing destination_account and amount

      before do
        post transfer_path,
             params: params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 422' do
        expect(response).to have_http_status :unprocessable_entity
        expect(json[:errors].first[:detail]).to eq 'Missing required parameters: destination_account, amount'
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
          account_id: 9999,
          destination_account: destination_account.id,
          amount: amount
        }
      end

      before do
        post transfer_path,
             params: invalid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns the account is not found' do
        expect(response).to have_http_status :not_found
        expect(json[:errors].first[:status]).to eq '404'
        expect(json[:errors].first[:title]).to eq 'Not Found'
      end
    end

    context 'when the destination account is not found' do
      let(:user) { create(:user) }
      let(:source_account) { create(:account_with_transaction, user: user) }
      let(:amount) { Faker::Commerce.price(range: 50..100.0, as_string: true) }
      let(:invalid_params) do
        {
          account_id: source_account.id,
          destination_account: 9999,
          amount: amount
        }
      end

      before do
        post transfer_path,
             params: invalid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns the account is not found' do
        expect(response).to have_http_status :not_found
        expect(json[:errors].first[:status]).to eq '404'
        expect(json[:errors].first[:title]).to eq 'Not Found'
      end
    end

    context 'when source and destination accounts are the same' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }
      let(:amount) { Faker::Commerce.price(range: 50..100.0, as_string: true) }
      let(:params) do
        {
          account_id: account.id,
          destination_account: account.id,
          amount: amount
        }
      end

      before do
        post transfer_path,
             params: params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns unprocessable entity error' do
        expect(response).to have_http_status :unprocessable_entity
        expect(json[:errors].first[:detail]).to eq 'Source and destination accounts must be different'
      end
    end

    context 'when amount is invalid' do
      let(:user) { create(:user) }
      let(:source_account) { create(:account_with_transaction, user: user) }
      let(:destination_account) { create(:account_with_transaction, user: user) }

      [
        { amount: 0, description: 'zero' },
        { amount: -100, description: 'negative' }
      ].each do |test_case|
        context "when amount is #{test_case[:description]}" do
          let(:params) do
            {
              account_id: source_account.id,
              destination_account: destination_account.id,
              amount: test_case[:amount]
            }
          end

          before do
            post transfer_path,
                 params: params,
                 headers: basic_credentials(user.cpf, user.password)
          end

          it 'returns unprocessable entity error' do
            expect(response).to have_http_status :unprocessable_entity
            expect(json[:errors].first[:detail]).to eq 'Amount must be positive'
          end
        end
      end
    end

    context 'when the balance from source account is not enough' do
      subject(:post_transfer) do
        post transfer_path,
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
          account_id: source_account.id,
          destination_account: destination_account.id,
          amount: amount
        }
      end

      it 'transaction is canceled' do
        post_transfer
        expect(response).to have_http_status :unprocessable_entity
        expect(json[:errors].first[:detail]).to eq 'Transaction canceled'
        expect(json[:errors].first[:status]).to eq '422'
        expect(json[:errors].first[:title]).to eq 'Insufficient Funds'
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
          account_id: source_account.id,
          destination_account: destination_account.id,
          amount: amount
        }
      end

      before do
        transaction = source_account.transactions.last
        transaction.amount = 500.0
        transaction.save!
        post transfer_path,
             params: valid_params,
             headers: basic_credentials(user.cpf, user.password)
      end

      it 'transfer is successful' do
        source_account.reload
        destination_account.reload
        expect(response).to have_http_status :created
        expect(json[:message]).to eq 'Transfer successful'
        expect(formatted_currency(source_account.current_balance)).
          to eq formatted_currency(500 - amount.to_f)
        expect(source_account.transactions.last.kind).to eq 'debit'
        expect(formatted_currency(destination_account.current_balance)).
          to eq formatted_currency(amount.to_f)
        expect(destination_account.transactions.last.kind).to eq 'credit'
      end
    end
  end

  describe 'GET /transactions/:id' do
    context 'when the user is unauthorized' do
      let(:user) { create(:user) }
      let(:account) { create(:account, user: user) }
      let(:transaction) { create(:transaction, account: account) }
      let(:id) { transaction.id }

      before do
        get transaction_path(id),
            headers: basic_credentials('user@email.com', '00000000')
      end

      it 'returns status code 401' do
        expect(response).to have_http_status :unauthorized
        expect(json[:errors].first[:status]).to eq '401'
        expect(json[:errors].first[:title]).to eq 'Unauthorized'
      end
    end

    context 'when the account is not found' do
      let(:user) { create(:user) }

      before do
        get transaction_path(500),
            params: { account_id: 42 },
            headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
        expect(json[:errors].first[:status]).to eq '404'
        expect(json[:errors].first[:title]).to eq 'Not Found'
      end
    end

    context 'when the transaction is not found' do
      let(:user) { create(:user) }
      let(:account) { create(:account_with_transaction, user: user) }

      before do
        get transaction_path(500),
            params: { account_id: account.id },
            headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns status code 404' do
        expect(response).to have_http_status :not_found
        expect(json[:errors].first[:status]).to eq '404'
        expect(json[:errors].first[:title]).to eq 'Not Found'
      end
    end

    context 'when the request is valid' do
      let(:user) { create(:user) }
      let(:account) { create(:account, user: user) }
      let(:transaction) { create(:transaction, account: account) }
      let(:id) { transaction.id }
      let(:kind) { transaction.kind }
      let(:amount) { transaction.amount }

      before do
        get transaction_path(id),
            params: { account_id: account.id },
            headers: basic_credentials(user.cpf, user.password)
      end

      it 'returns the transaction' do
        expect(response).to have_http_status :ok
        expect(json).not_to be_empty
        expect(json[:kind]).to eq kind
        expect(formatted_currency(json[:amount])).
          to eq formatted_currency(amount)
      end
    end
  end
end
