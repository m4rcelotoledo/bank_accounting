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
      @current_user = User.find_by(cpf: user)&.authenticate(pass)
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

  def validate_presence_of_required_params(required_params)
    missing_params = required_params.select { |param| params[param].blank? }

    return if missing_params.empty?

    render json: {
      errors: [
        {
          status: '422',
          title: 'Unprocessable Entity',
          detail: "Missing required parameters: #{missing_params.join(', ')}"
        }
      ]
    }, status: :unprocessable_entity
  end
end
