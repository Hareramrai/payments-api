# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(15, 10)
#  description      :string
#  transaction_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint
#
# Indexes
#
#  index_transactions_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Transaction < ApplicationRecord
  TRANSACTION_TYPES = %w[deposit withdraw overdraft_fee].freeze

  enum transaction_type: TRANSACTION_TYPES.zip(TRANSACTION_TYPES).to_h

  belongs_to :account

  validates :amount, numericality: { greater_than: 0 }
end
