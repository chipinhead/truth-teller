require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /api/v1/users" do
    let(:valid_attributes) do
      {
        user: {
          email: "test@example.com",
          name: "Test User"
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          email: "invalid-email",
          name: ""
        }
      }
    end

    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post "/api/v1/users", params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it "returns the created user" do
        post "/api/v1/users", params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(json_response["email"]).to eq("test@example.com")
        expect(json_response["name"]).to eq("Test User")
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect {
          post "/api/v1/users", params: invalid_attributes
        }.not_to change(User, :count)
      end

      it "returns unprocessable entity status" do
        post "/api/v1/users", params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to be_present
      end
    end
  end

  describe "GET /api/v1/users/:id" do
    let(:user) { create(:user) }

    context "when user exists" do
      it "returns the user" do
        get "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(:ok)
        expect(json_response["id"]).to eq(user.id)
        expect(json_response["email"]).to eq(user.email)
        expect(json_response["name"]).to eq(user.name)
      end
    end

    context "when user does not exist" do
      it "returns not found status" do
        get "/api/v1/users/0"
        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to eq("User not found")
      end
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
