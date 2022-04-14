# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Api::V1::AccountsController", type: :request, swagger_doc: SWAGGER_V1_DOC do
  include_context "sample accounts"

  let(:Authorization) { authenticate_headers(account_user)["Authorization"] }

  path "/accounts/" do
    post "Create a account" do
      tags "Accounts API"

      consumes MIME_APPLICATION_JSON
      security [jwt: []]

      parameter in: :body, name: :params, schema: { "$ref" => "#/components/schemas/new_account" }

      response "200", "Created a account" do
        let(:account) {  attributes_for(:account) }
        let(:params) { { account: account } }

        schema type: :object, properties: { "$ref" => "#/components/schemas/account" }

        run_test! do
          last_addded_account = account_user.accounts.last
          expect(last_addded_account.title).to eq(account[:title])
        end
      end

      response "422", "Validation failed for request" do
        let(:account) {  attributes_for(:account, title: "") }
        let(:params) { { account: account } }

        schema type: :object, properties: { "$ref" => "#/components/schemas/errors_object" }

        run_test!
      end
    end

    get "List of accounts with filters" do
      tags "Accounts API"

      consumes MIME_APPLICATION_JSON
      security [jwt: []]

      parameter name: :title, in: :query, type: :string

      response "200", "returns the filtered account when passing search query" do
        let(:title) { "account_one" }

        schema type: :array,
               items: { "$ref" => "#/components/schemas/account" }

        run_test! do
          expect(json_response(response).dig(0, :title)).to eq("account_one")
        end
      end
    end
  end
end
