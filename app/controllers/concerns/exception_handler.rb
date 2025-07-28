# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |error|
      json_response({ errors: [{ status: '404', title: 'Not Found', detail: error.message }] }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      json_response({ errors: [{ status: '422', title: 'Unprocessable Entity', detail: error.message }] }, :unprocessable_entity)
    end

    rescue_from InsufficientFunds do |error|
      json_response({ errors: [{ status: '422', title: 'Insufficient Funds', detail: error.message }] }, :unprocessable_entity)
    end

    rescue_from ArgumentError do |error|
      json_response({ errors: [{ status: '422', title: 'Unprocessable Entity', detail: error.message }] }, :unprocessable_entity)
    end
  end

  private

  def render_unauthorized
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

  def render_not_found(message = 'Resource not found')
    render json: {
      errors: [
        {
          status: '404',
          title: 'Not Found',
          detail: message
        }
      ]
    }, status: :not_found
  end

  def render_unprocessable_entity(message)
    render json: {
      errors: [
        {
          status: '422',
          title: 'Unprocessable Entity',
          detail: message
        }
      ]
    }, status: :unprocessable_entity
  end

  def render_missing_parameters(missing_params)
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
