# frozen_string_literal: true

require "rails_helper"

RSpec.describe Accounts::DepositService do
  let(:account) { create(:account) }

  subject { described_class.call(params) }

  describe ".call" do
    let(:params) { { account: account, amount: 20, description: "description" } }

    it "adds the amount to account" do
      expect { subject }.to change { account.amount }.by(20)
    end

    it "creates a transaction log as well" do
      expect { subject }.to change { account.transactions.count }.by(1)
      expect(account.transactions.last.transaction_type).to eq("deposit")
    end
  end
end
