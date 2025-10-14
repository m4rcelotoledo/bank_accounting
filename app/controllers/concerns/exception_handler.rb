# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |error|
      json_response({ errors: [{ status: '404', title: 'Not Found', detail: error.message }] }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      json_response({ errors: [{ status: '422', title: 'Unprocessable Entity', detail: error.message }] },
                    :unprocessable_content)
    end

    rescue_from InsufficientFunds do |error|
      json_response({ errors: [{ status: '422', title: 'Insufficient Funds', detail: error.message }] },
                    :unprocessable_content)
    end

    rescue_from ArgumentError do |error|
      json_response({ errors: [{ status: '422', title: 'Unprocessable Entity', detail: error.message }] },
                    :unprocessable_content)
    end

    rescue_from ActionController::ParameterMissing do |_error|
      json_response({
                      errors: [{ status: '422', title: 'Unprocessable Entity', detail: 'Missing required parameters' }]
                    },
                    :unprocessable_content)
    end
  end

  private

  def render_unauthorized
    render json: {
      errors: [
        {
          status: '401',
          title: 'Unauthorized',
          detail: 'Invalid or missing token'
        }
      ]
    }, status: :unauthorized
  end

  def render_invalid_credentials
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
