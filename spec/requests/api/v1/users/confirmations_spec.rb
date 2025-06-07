require 'rails_helper'

RSpec.describe "Api::V1::Users::Registrations", type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }
  let!(:user) do
    FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123', confirmation_token: '123456', confirmed_at: nil)
  end

  describe "POST /users/confirmation" do
    let(:valid_confirmation_params) do
      {
        user: {
          email: user.email
        }
      }
    end

    it "sends confirmation instructions" do
        user_spy = spy('user')
        allow(User).to receive(:find).and_return(user_spy)
        allow(user_spy).to receive(:send_confirmation_instructions)
        post "/users/confirmation", params: valid_confirmation_params.to_json, headers: headers
        expect(response).to have_http_status(:ok)
        puts "response: #{response.body}"
        expect(user_spy).to have_received(:send_confirmation_instructions)
      end
  end

  describe "GET /users/confirmation" do
    it "confirms the user" do
      get "/users/confirmation?confirmation_token=#{user.confirmation_token}"
      expect(response).to have_http_status(:ok)
      expect(response.headers['Authorization']).to be_present
      expect(response.headers['Authorization']).to start_with('Bearer ')
    end
    it "confirms denies user if token is invalid" do
        get "/users/confirmation?confirmation_token=invalid_token"
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("token is invalid")
      end
  end
end
