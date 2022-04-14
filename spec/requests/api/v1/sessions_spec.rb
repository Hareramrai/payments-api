# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Api::V1::SessionsController", type: :request, swagger_doc: SWAGGER_V1_DOC do
  let(:user) { create(:user, password: password) }

  path "/login" do
    post "Authenticate User" do
      tags "Authentication API"

      consumes MIME_APPLICATION_JSON

      parameter in: :body, name: :params, schema:  { "$ref" => "#/components/schemas/login" }

      response "200", "authenticates and returns a new token" do
        let(:password) { "mypassword1" }
        let(:params) { { email: user.email, password: password } }

        schema type: :object,
               properties: {
                 token: { type: :string },
               }, required: %w[token]

        run_test! do
          expect(json_response(response)).to eq(token: user.reload.token)
        end
      end

      response "400", "returns bad when password incorrect" do
        let(:password) { "my password" }
        let(:params) { { email: user.email, password: "incorrect password" } }

        schema properties: { "$ref" => "#/components/schemas/error_object" }

        run_test!
      end

      response "422", "returns validation when incorrect params" do
        let(:params) { attributes_for(:user, password: "") }

        schema properties: { "$ref" => "#/components/schemas/error_object" }

        run_test!
      end
    end
  end
end
