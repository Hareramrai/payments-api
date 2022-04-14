# frozen_string_literal: true

class Api::V1::UsersController < Api::BaseController
  before_action :authorize_request, only: [:update]
  before_action :set_user, only: [:update]

  # POST /users
  def create
    @user = User.new(user_params)
    @user.save!

    render json: @user
  end

  # PATCH/PUT /users/1
  def update
    current_user.update!(user_params)

    render json: @user
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password)
    end
end
