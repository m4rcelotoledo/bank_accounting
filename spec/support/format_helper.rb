# frozen_string_literal: true

module FormatHelper
  def formatted_currency(currency)
    format('%<value>.2f', value: currency)
  end
end
