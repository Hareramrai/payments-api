# frozen_string_literal: true

def json_response(response)
  JSON.parse(response.body, symbolize_names: true)
end

def authenticate_headers(user)
  Users::GenerateTokenService.call(user)

  { "Authorization" => "Bearer #{user.token}" }
end

def unauthenticate_headers
  { "Authorization" => "Bearer abc" }
end
