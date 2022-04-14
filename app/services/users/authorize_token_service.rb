# frozen_string_literal: true

class Users::AuthorizeTokenService < ApplicationService
  AUTH_SCHEME = "Bearer"

  delegate :token_expired?, to: :user

  def initialize(authorization_request)
    @authorization_request = authorization_request.to_s
  end

  def call
    if !validate_auth_scheme || token.blank? || user.blank?
      raise UnauthorizedException, I18n.t("api.errors.messages.invalid_token")
    end

    if token_expired?
      raise UnauthorizedException, I18n.t("api.errors.messages.expired_token")
    end

    user
  end

  private

    attr_reader :authorization_request

    def validate_auth_scheme
      authorization_request =~ /^#{AUTH_SCHEME} /o
    end

    def token
      @token ||= authorization_request.gsub("#{AUTH_SCHEME} ", "")
    end

    def user
      @user ||= User.find_by(token: token)
    end
end
