class ChangeValueFromTransactionsToDecimal < ActiveRecord::Migration[6.0]
  def change

    change_column :transactions, :value, :decimal
  end
end
