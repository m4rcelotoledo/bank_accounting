class UsersController < ApplicationController
  # POST /users
  def create
    @user = User.create!(user_params)

    json_response @user, :created
  end

  # GET /users
  def index
    @users = User.order(:name).page params[:page]

    json_response(@users)
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])

    json_response @user
  end

  private

  def user_params
    params.permit(:cpf, :name, :password)
  end
end
