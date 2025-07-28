# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionService, type: :service do
  subject(:transaction_service) { described_class }

  describe '.deposit' do
    let(:account) { create(:account) }
    let(:amount) { 100.0 }

    context 'when account exists' do
      it 'creates a credit transaction' do
        expect do
          transaction_service.deposit(account.id, amount)
        end.to change(Transaction, :count).by(1)

        transaction = Transaction.last
        expect(transaction.account_id).to eq account.id
        expect(transaction.amount).to eq amount
        expect(transaction.kind).to eq 'credit'
        expect(transaction.description).to eq 'Deposit'
      end
    end

    context 'when account does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          transaction_service.deposit(999, amount)
        end.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find Account with 'id'=999")
      end
    end
  end

  describe '.transfer!' do
    let(:source_account) { create(:account) }
    let(:destination_account) { create(:account) }
    let(:amount) { 100.0 }

    context 'when all parameters are valid' do
      before do
        create(:transaction, account: source_account, amount: 200, kind: 'credit')
      end

      it 'creates two transactions' do
        expect do
          transaction_service.transfer!(source_account.id, destination_account.id, amount)
        end.to change(Transaction, :count).by(2)

        debit_transaction = Transaction.where(account: source_account).last
        credit_transaction = Transaction.where(account: destination_account).last

        expect(debit_transaction.amount).to eq(-amount)
        expect(debit_transaction.kind).to eq 'debit'
        expect(debit_transaction.description).to eq "Transfer to account #{destination_account.id}"

        expect(credit_transaction.amount).to eq amount
        expect(credit_transaction.kind).to eq 'credit'
        expect(credit_transaction.description).to eq "Transfer from account #{source_account.id}"
      end
    end

    context 'when source and destination accounts are the same' do
      it 'raises ArgumentError' do
        expect do
          transaction_service.transfer!(source_account.id, source_account.id, amount)
        end.to raise_error(ArgumentError, 'Source and destination accounts must be different')
      end
    end

    context 'when amount is zero' do
      it 'raises ArgumentError' do
        expect do
          transaction_service.transfer!(source_account.id, destination_account.id, 0)
        end.to raise_error(ArgumentError, 'Amount must be positive')
      end
    end

    context 'when amount is negative' do
      it 'raises ArgumentError' do
        expect do
          transaction_service.transfer!(source_account.id, destination_account.id, -100)
        end.to raise_error(ArgumentError, 'Amount must be positive')
      end
    end

    context 'when source account has insufficient funds' do
      before do
        create(:transaction, account: source_account, amount: 50, kind: 'credit')
      end

      it 'raises InsufficientFunds' do
        expect do
          transaction_service.transfer!(source_account.id, destination_account.id, amount)
        end.to raise_error(InsufficientFunds, 'Transaction canceled')
      end
    end

    context 'when source account does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          transaction_service.transfer!(999, destination_account.id, amount)
        end.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find Account with 'id'=999")
      end
    end

    context 'when destination account does not exist' do
      before do
        create(:transaction, account: source_account, amount: 200, kind: 'credit')
      end

      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          transaction_service.transfer!(source_account.id, 999, amount)
        end.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find Account with 'id'=999")
      end
    end

    context 'when both accounts do not exist' do
      it 'raises ActiveRecord::RecordNotFound for source account' do
        expect do
          transaction_service.transfer!(999, 888, amount)
        end.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find Account with 'id'=999")
      end
    end
  end
end
