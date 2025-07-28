# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # In development, allow localhost
    origins 'http://localhost:3000', 'http://localhost:3001', 'http://127.0.0.1:3000'

    resource '*',
      headers: :any,
      methods: %i[get post put patch delete options head],
      credentials: false
  end

  # In production, configure specific origins
  # allow do
  #   origins 'https://yourdomain.com', 'https://api.yourdomain.com'
  #
  #   resource '*',
  #     headers: :any,
  #     methods: %i[get post put patch delete options head],
  #     credentials: true
  # end
end
