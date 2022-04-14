# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id              :bigint           not null, primary key
#  amount          :decimal(15, 10)
#  iban            :string
#  lock_version    :integer          default(0)
#  overdraft_limit :decimal(15, 10)  default(0.0)
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_accounts_on_iban     (iban) UNIQUE
#  index_accounts_on_title    (title)
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy
  belongs_to :user

  validates :iban, presence: true, uniqueness: { case_sensitive: false }
  validates :title, presence: true
  validates :overdraft_limit, numericality: { greater_than_or_equal_to: 0 }
  validate :amount_with_over_draft_limit

  private

    def amount_with_over_draft_limit
      return unless (amount + overdraft_limit).negative?

      errors.add(:amount, "can't be less than zero")
    end
end
