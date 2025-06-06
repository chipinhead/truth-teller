require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }

  describe "Full user flow: register, login, get current user" do
    let(:unique_email) { "testuser_#{Time.current.to_i}_#{rand(1000)}@example.com" }
    
    let(:user_attributes) do
      {
        user: {
          email: unique_email,
          name: 'Test User Flow',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    let(:login_credentials) do
      {
        user: {
          email: unique_email,
          password: 'password123'
        }
      }
    end

    it "creates user, logs them in, and returns current user" do
      # Step 1: Register a new user
      expect {
        post "/users", params: user_attributes.to_json, headers: headers
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:ok)
      registration_response = JSON.parse(response.body)
      expect(registration_response['message']).to eq('Signed up.')
      expect(registration_response['user']['email']).to eq(unique_email)
      
      user_id = registration_response['user']['id']

      # Step 2: Login to get JWT token
      post "/users/sign_in", params: login_credentials.to_json, headers: headers
      
      expect(response).to have_http_status(:ok)
      login_response = JSON.parse(response.body)
      expect(login_response['message']).to eq('Logged in.')
      
      # Extract JWT token from Authorization header
      jwt_token = response.headers['Authorization']
      expect(jwt_token).to be_present
      expect(jwt_token).to start_with('Bearer ')

      # Step 3: Use JWT token to get current user
      auth_headers = headers.merge('Authorization' => jwt_token)
      get "/api/v1/users/current", headers: auth_headers

      expect(response).to have_http_status(:ok)
      current_user_response = JSON.parse(response.body)
      
      # Verify current user is the same user we registered and logged in
      expect(current_user_response['id']).to eq(user_id)
      expect(current_user_response['email']).to eq(unique_email)
      expect(current_user_response['name']).to eq('Test User Flow')
      expect(current_user_response).to include('created_at', 'updated_at')
    end

    it "returns 401 when accessing current user without JWT token" do
      get "/api/v1/users/current", headers: headers

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns 401 when accessing current user with invalid JWT token" do
      invalid_auth_headers = headers.merge('Authorization' => 'Bearer invalid_token')
      get "/api/v1/users/current", headers: invalid_auth_headers

      expect(response).to have_http_status(:unauthorized)
    end
  end
end 