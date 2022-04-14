# frozen_string_literal: true

class Api::V1::SessionsController < Api::BaseController
  # POST /login
  def create
    authenticate_user = Users::AuthenticationService.call(session_params)

    if authenticate_user
      Users::GenerateTokenService.call(authenticate_user)

      render json: { token: authenticate_user.token }
    else
      render json: { error: I18n.t("api.errors.messages.invalid_credentials") },
             status: :bad_request
    end
  end

  private

    def session_params
      params.require(:session).permit(:email, :password)
    end
end
