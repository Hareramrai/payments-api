# frozen_string_literal: true

require "rails_helper"

RSpec.describe Accounts::IndexQuery do
  include_context "sample accounts"

  describe "#call" do
    context "search by title" do
      context "when title matches" do
        let(:search_params) { { title: "account_one" } }

        it "returns the searched result" do
          expect(subject.call(search_params)).to eq([account_one])
        end
      end

      context "when title does not match" do
        let(:search_params) { { title: "nomatch" } }

        it "returns no record" do
          expect(subject.call(search_params)).to be_blank
        end
      end
    end

    context "search by iban" do
      context "when iban matches" do
        let(:search_params) { { iban: "account_one_iban" } }

        it "returns the searched result" do
          expect(subject.call(search_params)).to eq([account_one])
        end
      end

      context "when iban does not match" do
        let(:search_params) { { iban: "1234" } }

        it "returns no record" do
          expect(subject.call(search_params)).to be_blank
        end
      end
    end
  end
end
