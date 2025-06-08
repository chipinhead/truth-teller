require 'rails_helper'

RSpec.describe "Api::V1::UserClients", type: :request do
  describe "GET /api/v1/users/:user_id/clients" do
    context "when authenticated" do
      let(:user) { FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123') }
      let(:other_user) { FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123') }
      let!(:clients) { FactoryBot.create_list(:client, 3, created_user: user) }

      before do
        # Associate 2 clients with the user
        user.clients << clients[0]
        user.clients << clients[1]
        # Third client is not associated
      end

      it "returns a list of clients associated with the user" do
        get "/api/v1/users/#{user.id}/clients", headers: authenticated_headers

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(user.clients.length)
        expect(json_response.map { |c| c['name'] }).to match_array(user.clients.map(&:name))
      end

      it "returns empty array when user has no associated clients" do
        get "/api/v1/users/#{other_user.id}/clients", headers: authenticated_headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to eq([])
      end

      it "returns 404 when user does not exist" do
        get "/api/v1/users/non-existent-uuid/clients", headers: authenticated_headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User not found')
      end
    end

    context "when not authenticated" do
      let(:user) { FactoryBot.create(:user) }

      it "returns 401 unauthorized" do
        get "/api/v1/users/#{user.id}/clients", headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end 