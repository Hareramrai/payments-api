# frozen_string_literal: true

class Users::AuthenticationService < ApplicationService
  delegate :email, :password, to: :contract

  def initialize(login_params)
    @contract = LoginContract.new(email: login_params[:email],
                                  password: login_params[:password])
  end

  def call
    contract.validate!
    authenticate
  end

  attr_reader :contract

  def authenticate
    user = User.find_by(email: email)
    return user if user&.authenticate(password)

    nil
  end
end
