# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Api::V1::Accounts::WithdrawsController", type: :request, swagger_doc: SWAGGER_V1_DOC do
  let!(:user) { create(:user) }
  let!(:account) { create(:account, user: user, amount: 20) }
  let(:account_id) { account.id }
  let(:Authorization) { authenticate_headers(user)["Authorization"] }

  path "/accounts/{account_id}/withdraws" do
    post "does withdraws from a account" do
      tags "Withdraws API"

      consumes MIME_APPLICATION_JSON
      security [jwt: []]

      parameter name: :account_id, in: :path, type: :string
      parameter in: :body, name: :params, schema: { "$ref" => "#/components/schemas/new_withdraw" }

      response "200", "deducts amounts from account" do
        let(:params) { { withdraw: { amount: 10, description: "atm withdraw" } } }

        schema type: :object, properties: { "$ref" => "#/components/schemas/account" }

        run_test! do
          expect(account.reload.amount).to eq(10)
        end
      end

      response "422", "Validation failed if amount goes in negative" do
        let(:params) { { withdraw: { amount: 30, description: "atm withdraw" } } }

        schema type: :object, properties: { "$ref" => "#/components/schemas/errors_object" }

        run_test!
      end
    end
  end
end
