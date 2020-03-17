class RenameTransactionValueToAmount < ActiveRecord::Migration[6.0]
  def change

    rename_column :transactions, :value, :amount
  end
end
