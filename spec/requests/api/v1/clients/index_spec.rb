require 'rails_helper'

RSpec.describe "Api::V1::Clients", type: :request do
  describe "GET /api/v1/clients" do
    context "when authenticated" do
      let!(:user) { FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123') }
      let!(:clients) { FactoryBot.create_list(:client, 2, created_user: user) }

      it "returns a list of clients" do
        get "/api/v1/clients", headers: authenticated_headers

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
        expect(json_response.map { |c| c['name'] }).to match_array(clients.map(&:name))
      end
    end

    context "when not authenticated" do
      it "returns 401 unauthorized" do
        get "/api/v1/clients", headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns 401 with invalid token" do
        invalid_headers = json_headers.merge('Authorization' => 'Bearer invalid_token')
        
        get "/api/v1/clients", headers: invalid_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end