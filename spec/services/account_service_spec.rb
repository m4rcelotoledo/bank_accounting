# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountService, type: :service do
  subject(:account_service) { described_class }

  describe '.balance_initial' do
    let(:account) { create(:account) }

    it 'creates an initial balance transaction' do
      expect do
        account_service.balance_initial(account.id)
      end.to change(Transaction, :count).by(1)

      transaction = Transaction.last
      expect(transaction.account_id).to eq account.id
      expect(transaction.description).to eq 'Initial balance'
      expect(transaction.kind).to eq 'initial_balance'
      expect(transaction.amount).to eq 0
    end
  end

  describe '.sufficient_funds?' do
    let(:account) { create(:account) }

    context 'when account does not exist' do
      it 'returns false' do
        expect(account_service.sufficient_funds?(999, 100)).to be false
      end
    end

    context 'when account exists' do
      context 'when account has no transactions' do
        it 'returns false' do
          expect(account_service.sufficient_funds?(account.id, 100)).to be false
        end
      end

      context 'when account has transactions but insufficient balance' do
        before do
          create(:transaction, account: account, amount: 50, kind: 'credit')
        end

        it 'returns false for amount greater than balance' do
          expect(account_service.sufficient_funds?(account.id, 100)).to be false
        end

        it 'returns true for amount equal to balance' do
          expect(account_service.sufficient_funds?(account.id, 50)).to be true
        end
      end

      context 'when account has sufficient balance' do
        before do
          create(:transaction, account: account, amount: 200, kind: 'credit')
        end

        it 'returns true for amount less than balance' do
          expect(account_service.sufficient_funds?(account.id, 100)).to be true
        end

        it 'returns true for amount equal to balance' do
          expect(account_service.sufficient_funds?(account.id, 200)).to be true
        end
      end

      context 'when account has negative balance' do
        before do
          create(:transaction, account: account, amount: -50, kind: 'debit')
        end

        it 'returns false' do
          expect(account_service.sufficient_funds?(account.id, 100)).to be false
        end
      end

      context 'when account has zero balance' do
        before do
          create(:transaction, account: account, amount: 0, kind: 'initial_balance')
        end

        it 'returns false' do
          expect(account_service.sufficient_funds?(account.id, 100)).to be false
        end
      end
    end
  end
end
