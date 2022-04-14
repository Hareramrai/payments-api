# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::GenerateTokenService do
  let(:user) { create(:user) }

  describe ".call" do
    it "generates a new token" do
      old_token = user.token
      described_class.call(user)

      expect(old_token).not_to eq(user.reload.token)
    end
  end
end
