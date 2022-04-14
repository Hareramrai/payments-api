# frozen_string_literal: true

class Accounts::DepositService < ApplicationService
  def initialize(account:, amount:, description:)
    @account = account
    @amount = amount
    @description = description
  end

  def call
    account.transaction do
      account.amount += amount
      account.save!
      account.transactions.create!(
        amount: amount, description: description,
        transaction_type: "deposit"
      )
    end
  rescue ActiveRecord::StaleObjectError
    retry
  end

  private

    attr_reader :account, :amount, :description
end
