class RemoveBalanceFromTransactions < ActiveRecord::Migration[6.0]
  def change

    remove_column :transactions, :balance, :float
  end
end
