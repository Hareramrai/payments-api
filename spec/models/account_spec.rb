# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id              :bigint           not null, primary key
#  amount          :decimal(15, 10)
#  iban            :string
#  lock_version    :integer          default(0)
#  overdraft_limit :decimal(15, 10)  default(0.0)
#  title           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_accounts_on_iban     (iban) UNIQUE
#  index_accounts_on_title    (title)
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Account, type: :model do
  subject { described_class.new(amount: 0, overdraft_limit: 0) }
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }

    describe "amount" do
      subject { build(:account, overdraft_limit: 10, amount: -5) }

      it "would be greater_than_or_equal_to with combination of overdraft_limit" do
        expect(subject).to be_valid
      end
    end

    context "uniqueness" do
      subject { build(:account) }
      it { is_expected.to validate_uniqueness_of(:iban).case_insensitive }
    end
  end

  describe "relationships" do
    it { is_expected.to have_many(:transactions).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end
end
