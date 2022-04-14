# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::AuthorizeTokenService do
  let(:user) { create(:user) }

  subject { described_class.call(params) }

  describe ".call" do
    context "when passing valid authorization_request" do
      let(:params) { "Bearer #{user.token}" }

      before { Users::GenerateTokenService.call(user) }

      it "returns the user" do
        expect(subject).to eq(user)
      end
    end

    context "when passing invalid authorization_request" do
      let(:params) { "Bearer xxx" }

      it "raise UnauthorizedException error" do
        expect { subject }.to raise_error(UnauthorizedException)
      end
    end
  end
end
