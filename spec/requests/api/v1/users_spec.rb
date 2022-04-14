# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Api::V1::UsersController", type: :request, swagger_doc: SWAGGER_V1_DOC do
  path "/users/" do
    post "Create a user" do
      tags "Users API"

      consumes MIME_APPLICATION_JSON

      parameter in: :body, name: :params, schema: { "$ref" => "#/components/schemas/new_user" }

      response "200", "Created a user" do
        let(:user) {  attributes_for(:user) }
        let(:params) { { user: user } }

        schema type: :object, properties: { "$ref" => "#/components/schemas/user" }

        run_test! do
          last_addded_user = User.last
          expect(User.find_by(email: user[:email])).to eq(last_addded_user)
        end
      end

      response "422", "Validation failed for request" do
        let(:user) { attributes_for(:user, email: "hare", password: "123") }
        let(:params) { { user: user } }

        schema type: :object, properties: { "$ref" => "#/components/schemas/errors_object" }

        run_test!
      end
    end
  end

  path "/users/{id}" do
    patch "Update a user" do
      tags "Users API"

      consumes MIME_APPLICATION_JSON
      produces MIME_APPLICATION_JSON
      security [jwt: []]

      parameter in: :body, name: :params, schema: { "$ref" => "#/components/schemas/new_user" }
      parameter name: :id, in: :path, type: :string

      let!(:user) { create(:user) }
      let!(:id) { user.id }
      let(:Authorization) { authenticate_headers(user)["Authorization"] }

      response "200", "Updated a user" do
        let(:new_email) { "myemail@example.com" }
        let(:params) { { user: { email: new_email } } }

        schema type: :object, properties: { "$ref" => "#/components/schemas/user" }

        run_test! do
          expect(new_email).to eq(user.reload.email)
        end
      end

      response "422", "Validation failed for request" do
        let(:new_email) { "myemail" }
        let(:params) { { user: { email: new_email } } }

        schema type: :object, properties: { "$ref" => "#/components/schemas/errors_object" }

        run_test!
      end
    end
  end
end
