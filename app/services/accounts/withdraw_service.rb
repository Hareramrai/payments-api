# frozen_string_literal: true

class Accounts::WithdrawService < ApplicationService
  OVER_DRAFT_FEE = 2
  def initialize(account:, amount:, description:)
    @account = account
    @amount = amount
    @description = description
  end

  def call
    account.transaction do
      account.amount -= amount

      account.save!

      account.transactions.create!(
        amount: amount, description: description,
        transaction_type: "withdraw"
      )

      if account.amount.negative?
        account.transactions.create!(
          amount: OVER_DRAFT_FEE,
          transaction_type: "overdraft_fee"
        )
      end
    end
  rescue ActiveRecord::StaleObjectError
    retry
  end

  private

    attr_reader :account, :amount, :description
end
