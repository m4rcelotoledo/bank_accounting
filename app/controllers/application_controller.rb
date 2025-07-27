# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ExceptionHandler
  include Response

  before_action :authenticate

  private

  attr_reader :current_user

  def authenticate
    return if authenticate_with_http_basic do |user, pass|
      @current_user = User.find_by(cpf: user).try(:authenticate, pass)
    end

    render json: {
      errors: [
        {
          status: '401',
          title: 'Unauthorized',
          detail: 'Invalid credentials'
        }
      ]
    }, status: :unauthorized
  end
end
