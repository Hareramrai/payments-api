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
require "rails_helper"

RSpec.describe Transaction, type: :model do
  let(:account) { create(:account) }

  describe "validations" do
    subject { described_class.new(account: account) }

    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe "relationships" do
    it { is_expected.to belong_to(:account) }
  end
end
