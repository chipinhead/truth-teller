require 'rails_helper'

RSpec.describe "Api::V1::Users::Registrations", type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }

  describe "POST /users" do
    let(:unique_email) { "test_#{Time.current.to_i}_#{rand(1000)}@example.com" }
    
    let(:valid_attributes) do
      {
        user: {
          email: unique_email,
          name: 'Test User',
          password: 'password123',
          password_confirmation: 'password123'
        }
      }
    end

    it "creates a new user" do
      expect {
        post "/users", params: valid_attributes.to_json, headers: headers
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Signed up.')
      expect(json_response['user']).to include('email' => unique_email)
      expect(json_response['user']).to include('name' => 'Test User')
      expect(json_response['user']).to include('id')

      user = User.last
      expect(user.email).to eq(unique_email)
      expect(user.name).to eq('Test User')
    end
  end
end 