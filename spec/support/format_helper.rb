module FormatHelper
  # Format currency to nn.dd => '13.60'
  def formatted_currency(currency)
    format('%.2f', currency)
  end
end
