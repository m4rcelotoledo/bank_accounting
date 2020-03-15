# frozen_string_literal: true

module RequestHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end
end
