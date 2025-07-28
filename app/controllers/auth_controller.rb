# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authenticate, only: [:login]

  # POST /auth/login
  def login
    user = User.find_by(cpf: params[:cpf])

    if user&.authenticate(params[:password])
      token = JwtService.generate_token(user)
      render json: {
        token: token,
        user: {
          id: user.id,
          name: user.name,
          cpf: user.cpf
        }
      }, status: :ok
    else
      render_invalid_credentials
    end
  end

  # POST /auth/logout
  def logout
    # In a more robust implementation, you could add the token to a blacklist
    # For simplicity, we just return success
    render json: { message: 'Logout successful' }, status: :ok
  end

  # GET /auth/me
  def me
    render json: {
      user: {
        id: current_user.id,
        name: current_user.name,
        cpf: current_user.cpf
      }
    }, status: :ok
  end
end
