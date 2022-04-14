# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::AuthenticationService do
  let(:user) { create(:user) }

  subject { described_class.call(params) }

  describe ".call" do
    context "when passing valid params" do
      let(:params) { { email: user.email, password: user.password } }

      it "returns the user" do
        expect(subject).to eq(user)
      end
    end

    context "when passing invalid params" do
      let(:params) { { email: user.email, password: "" } }

      it "raise the validation error" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
