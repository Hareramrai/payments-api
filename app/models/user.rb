# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  email            :string
#  password_digest  :string
#  token            :string
#  token_expires_at :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_token  (token) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_secure_token :token

  has_many :accounts, dependent: :destroy

  attribute :password

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, email: true, allow_blank: true
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 8 }, if: :password_exist?

  before_save { email.downcase! }

  def token_expired?
    token_expires_at < Time.current
  end

  private

    def password_exist?
      password&.length&.positive?
    end
end
