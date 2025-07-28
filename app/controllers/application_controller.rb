# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ExceptionHandler
  include Response

  before_action :authenticate

  private

  attr_reader :current_user

  def authenticate
    header = request.headers['Authorization']
    token = header.split.last if header

    if token
      decoded = JwtService.decode(token)
      if decoded
        @current_user = User.find_by(id: decoded['user_id'])
        return if @current_user
      end
    end

    render_unauthorized
  end
end
