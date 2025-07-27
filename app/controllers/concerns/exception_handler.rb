# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |error|
      json_response({
                      errors: [
                        {
                          status: '404',
                          title: 'Not Found',
                          detail: error.message
                        }
                      ]
                    }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      json_response({
                      errors: [
                        {
                          status: '422',
                          title: 'Unprocessable Entity',
                          detail: error.message
                        }
                      ]
                    }, :unprocessable_entity)
    end

    rescue_from InsufficientFunds do |error|
      json_response({
                      errors: [
                        {
                          status: '422',
                          title: 'Insufficient Funds',
                          detail: error.message
                        }
                      ]
                    }, :unprocessable_entity)
    end
  end
end
