# frozen_string_literal: true

class JwtService
  ALGORITHM = 'HS256'

  def self.secret_key
    if Rails.env.production?
      Rails.application.credentials.secret_key_base || raise('Missing secret_key_base in credentials for production!')
    end

    Rails.application.credentials.secret_key_base || 'fallback_secret_key_for_jwt_development'
  end

  def self.encode(payload)
    JWT.encode(payload, secret_key, ALGORITHM)
  end

  def self.decode(token)
    decoded = JWT.decode(token, secret_key, true, { algorithm: ALGORITHM })
    decoded[0]
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    Rails.logger.error "JWT decode error: #{e.message}"
    nil
  end

  def self.generate_token(user)
    payload = {
      user_id: user.id,
      cpf: user.cpf,
      exp: 24.hours.from_now.to_i
    }
    encode(payload)
  end
end
