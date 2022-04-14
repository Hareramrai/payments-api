# frozen_string_literal: true

require "rails_helper"

RSpec.describe Accounts::WithdrawService do
  let(:overdraft_limit) { 0 }
  let(:account) { create(:account, amount: initial_amount, overdraft_limit: overdraft_limit) }

  subject { described_class.call(params) }

  describe ".call" do
    let(:params) { { account: account, amount: 20, description: "description" } }

    context "when account has more money than withdraw amount" do
      let(:initial_amount) { 40 }

      it "deducts the amount from the account" do
        expect { subject }.to change { account.amount }.by(-20)
      end

      it "creates a transaction log as well" do
        expect { subject }.to change { account.transactions.count }.by(1)
        expect(account.transactions.last.transaction_type).to eq("withdraw")
      end
    end

    context "when account has less money than withdraw amount" do
      let(:initial_amount) { 10 }

      it "raise an exception" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe "with overdraft_limit" do
      let(:params) { { account: account, amount: 80, description: "description" } }

      context "when account has less money than withdraw amount & overdraft limit is sufficient" do
        let(:initial_amount) { 10 }
        let(:overdraft_limit) { 100 }

        it "won't raie an exception" do
          expect { subject }.not_to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "when account has less money than withdraw amount & overdraft limit is less" do
        let(:initial_amount) { 10 }
        let(:overdraft_limit) { 10 }

        it "raise an exception" do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
