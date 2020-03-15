# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :account, foreign_key: true
      t.integer :kind
      t.float :value
      t.float :balance

      t.timestamps
    end
  end
end
