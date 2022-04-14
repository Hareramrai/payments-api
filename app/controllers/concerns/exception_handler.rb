# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error
    rescue_from UnauthorizedException, with: :handle_unauthorized

    def handle_validation_error(exception)
      render json: { errors: exception.message }, status: :unprocessable_entity
    end

    def handle_record_not_found(exception)
      render json: { errors: exception.message }, status: :not_found
    end

    def handle_unauthorized(exception)
      render json: { error: exception.message }, status: :unauthorized
    end
  end
end
