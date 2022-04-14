# frozen_string_literal: true

RSpec.shared_context "sample accounts" do
  let(:account_user) { create(:user) }
  let!(:account_one) { create(:account, title: "account_one", user: account_user, iban: "account_one_iban") }
  let!(:account_two) { create(:account, title: "account_two", user: account_user) }
end
