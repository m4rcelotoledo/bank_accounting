# frozen_string_literal: true

class AddDescriptionToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :description, :string
  end
end
