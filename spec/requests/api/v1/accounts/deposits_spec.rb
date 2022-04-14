# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Api::V1::Accounts::DepositsController", type: :request, swagger_doc: SWAGGER_V1_DOC do
  let!(:user) { create(:user) }
  let(:account) { create(:account, user: user, amount: 0) }
  let(:account_id) { account.id }
  let(:Authorization) { authenticate_headers(user)["Authorization"] }

  path "/accounts/{account_id}/deposits" do
    post "does deposits to a account" do
      tags "Deposits API"

      consumes MIME_APPLICATION_JSON
      security [jwt: []]

      parameter name: :account_id, in: :path, type: :string
      parameter in: :body, name: :params, schema: { "$ref" => "#/components/schemas/new_deposit" }

      response "200", "add amounts to account" do
        let(:params) { { deposit: { amount: 10, description: "atm deposit" } } }

        schema type: :object, properties: { "$ref" => "#/components/schemas/account" }

        run_test! do
          expect(account.reload.amount).to eq(10)
        end
      end

      response "422", "Validation failed for request" do
        let(:params) { { deposit: { amount: -10, description: "atm deposit" } } }

        schema type: :object, properties: { "$ref" => "#/components/schemas/errors_object" }

        run_test!
      end
    end
  end
end
