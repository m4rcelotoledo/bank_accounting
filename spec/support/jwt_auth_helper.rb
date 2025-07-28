# frozen_string_literal: true

module JwtAuthHelper
  # JWT token request headers
  def jwt_credentials(user)
    token = JwtService.generate_token(user)
    {
      'HTTP_AUTHORIZATION' => "Bearer #{token}"
    }
  end

  # Create a user and return JWT credentials
  def create_user_with_jwt(cpf: '12345678901', password: 'password123')
    user = create(:user, cpf: cpf, password: password)
    jwt_credentials(user)
  end
end
