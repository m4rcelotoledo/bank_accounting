# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate, only: :create

  # GET /users
  def index
    User.includes(:account).order(:name).page(params[:page]).then do |users|
      json_response users
    end
  end

  # GET /users/:id
  def show
    User.includes(:account).find(params[:id]).then do |user|
      json_response user
    end
  end

  # POST /users
  def create
    User.create!(user_params).then do |user|
      json_response user, :created
    end
  end

  private

  def user_params
    params.permit(:cpf, :name, :password)
  end
end
