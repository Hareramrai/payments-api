# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  email            :string
#  password_digest  :string
#  token            :string
#  token_expires_at :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_token  (token) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }

    context "uniqueness" do
      subject { build(:user) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe "relationships" do
    it { is_expected.to have_many(:accounts).dependent(:destroy) }
  end
end
