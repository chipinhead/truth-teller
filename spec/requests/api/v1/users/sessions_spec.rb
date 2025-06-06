require 'rails_helper'

RSpec.describe "Api::V1::Users::Sessions", type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }
  
  let!(:user) do
    User.create!(
      email: 'test@example.com',
      name: 'Test User',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  describe "POST /users/sign_in" do
    let(:valid_credentials) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123'
        }
      }
    end

    let(:invalid_credentials) do
      {
        user: {
          email: 'test@example.com',
          password: 'wrongpassword'
        }
      }
    end

    context "with valid credentials" do
      it "signs in the user and returns a JWT token" do
        post "/users/sign_in", params: valid_credentials.to_json, headers: headers

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Logged in.')
        expect(json_response['user']).to include('email' => 'test@example.com')
        expect(json_response['user']).to include('name' => 'Test User')
        expect(json_response['user']).to include('id')

        # Check that JWT token is present in Authorization header
        expect(response.headers['Authorization']).to be_present
        expect(response.headers['Authorization']).to start_with('Bearer ')
      end
    end

    context "with invalid credentials" do
      it "returns an error" do
        post "/users/sign_in", params: invalid_credentials.to_json, headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /users/sign_out" do
    let(:jwt_token) do
      # First sign in to get a token
      post "/users/sign_in", params: valid_credentials.to_json, headers: headers
      response.headers['Authorization']
    end

    let(:valid_credentials) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123'
        }
      }
    end

    it "signs out the user" do
      auth_headers = headers.merge('Authorization' => jwt_token)
      
      delete "/users/sign_out", headers: auth_headers

      expect(response).to have_http_status(:no_content)
    end
  end
end 