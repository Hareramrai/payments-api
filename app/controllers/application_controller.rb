# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Helpers

  private

    def authorize_request
      @current_user = Users::AuthorizeTokenService.call(request.authorization)
    end

    attr_reader :current_user

    helper_method :current_user
end
