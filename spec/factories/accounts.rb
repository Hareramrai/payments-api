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
FactoryBot.define do
  factory :account do
    sequence :title do |n|
      "title #{n}"
    end

    amount { 10.50 }

    sequence :iban do |n|
      "iban #{n}"
    end
    user
  end
end
