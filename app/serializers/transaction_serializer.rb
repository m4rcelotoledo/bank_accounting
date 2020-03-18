# frozen_string_literal: true

class TransactionSerializer < ActiveModel::Serializer
  attributes :date, :document, :description, :kind, :amount

  def date
    object.created_at.utc
  end

  def document
    "##{object.account_id}##{object.id}"
  end

  def amount
    object.amount.to_f
  end
end
