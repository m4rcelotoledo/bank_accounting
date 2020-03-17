# frozen_string_literal: true

module RequestHelper
  # Parse JSON response to ruby hash
  def json(body = response.body)
    JSON.parse(body, symbolize_names: true)
  end
end
