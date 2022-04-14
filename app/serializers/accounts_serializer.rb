# frozen_string_literal: true

class AccountSerializer < ActiveModel::Serializer
  attributes :id, :title, :iban, :amount, :overdraft_limit

  has_many :transactions
  belongs_to :user
end
