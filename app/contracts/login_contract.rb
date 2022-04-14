# frozen_string_literal: true

class LoginContract < ApplicationContract
  attr_reader :email, :password

  def initialize(email:, password:)
    @email = email.downcase
    @password = password
  end

  validates :email, presence: true, email: true
  validates :password, presence: true, length: { minimum: 8 }
end
