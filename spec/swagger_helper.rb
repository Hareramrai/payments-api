# frozen_string_literal: true

require "rails_helper"

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join("swagger").to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "API V1",
        version: "v1",
      },
      basePath: "/api/v1",
      servers: [
        {
          url: "http://{defaultHost}",
          variables: {
            defaultHost: {
              default: "localhost:3000/api/v1",
            },
          },
        },
      ],
      components: {
        securitySchemes: {
          jwt: {
            type: :apiKey,
            description: "Bearer ey....",
            name: "Authorization",
            in: :header,
          },
        },
        schemas: {
          error_object: {
            type: :object,
            properties: {
              error: {
                type: :string,
                description: "Message",
              },
            },
          },
          errors_object: {
            type: :object,
            properties: {
              errors: { "$ref" => "#/components/schemas/errors_map" },
            },
          },
          errors_map: {
            type: :object,
            additionalProperties: {
              type: "array",
              items: { type: "string" },
            },
          },
          login: {
            type: :object,
            properties: {
              session: { "$ref" => "#/components/schemas/user_field" },
            },
            required: ["session"],
          },
          new_user: {
            type: :object,
            properties: {
              user: { "$ref" => "#/components/schemas/user_field" },
            },
            required: %w[user],
          },
          user_field: {
            type: :object,
            properties: {
              email: {
                type: :string,
                description: "Email",
                example: "myemail@example.com",
              },
              password: {
                type: :string,
                description: "Password",
                example: "Password1234",
              },
            },
            required: %w[email password],
          },
          user: {
            type: :object,
            properties: {
              id: {
                type: :integer,
                description: "ID",
              },
              email: {
                type: :string,
                description: "Email",
                example: "myemail@example.com",
              },
              created_at: {
                type: :string,
                format: :date,
              },
              updated_at: {
                type: :string,
                format: :date,
              },
            },
          },
          account: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string, description: "account title and searchable" },
              iban: { type: :string, description: "iban number and searchable" },
              amount: { type: :decimal, description: "Currenrly hold account balance" },
              overdraft_limit: { type: :decimal, description: "overdraft_limit allowed" },
              transactions: {
                type: :array,
                items: { "$ref" => "#/components/schemas/transaction" },
              },
            },
          },
          transaction: {
            type: :object,
            properties: {
              id: { type: :integer },
              amount: { type: :decimal },
              transaction_type: { type: :string, description: "could be deposit or withdraw" },
              description: { type: :string },
            },
          },
          new_deposit: {
            type: :object,
            properties: {
              deposit: {
                type: :object,
                properties: {
                  amount: { type: :decimal, description: "has to be greater than zero" },
                  description: { type: :string },
                },
              },
              required: %w[amount],
            },
            required: %w[deposit],
          },
          new_withdraw: {
            type: :object,
            properties: {
              withdraw: {
                type: :object,
                properties: {
                  amount: { type: :number, description: "has to be greater than zero" },
                  description: { type: :string },
                },
              },
              required: %w[amount],
            },
            required: %w[withdraw],
          },
          new_account: {
            type: :object,
            properties: {
              account: {
                type: :object,
                properties: {
                  amount: { type: :number, description: "has to be greater than zero" },
                  title: { type: :string },
                  iban: { type: :string },
                },
              },
              required: %w[amount title iban],
            },
            required: %w[account],
          },
        },
      },
    },
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :json
end
