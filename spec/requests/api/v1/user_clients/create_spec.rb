require 'rails_helper'

RSpec.describe "Api::V1::UserClients", type: :request do
  describe "POST /api/v1/users/:user_id/clients/:client_id" do
    context "when authenticated" do
      let(:user) { FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123') }
      let(:client) { FactoryBot.create(:client, created_user: user) }
      let(:other_client) { FactoryBot.create(:client, created_user: user) }

      it "successfully adds a client to a user" do
        expect {
          post "/api/v1/users/#{user.id}/clients", 
               params: { id: client.id }.to_json, 
               headers: authenticated_headers
        }.to change { user.clients.count }.by(1)

        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Client successfully added to user')
        
        # Verify the association was created
        expect(user.clients).to include(client)
      end

      it "returns ok when client is already associated with user" do
        # Pre-associate the client
        user.clients << client

        expect {
          post "/api/v1/users/#{user.id}/clients", 
               params: { id: client.id }.to_json, 
               headers: authenticated_headers
        }.not_to change { user.clients.count }

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('User is already associated with this client')
      end

      it "returns 404 when user does not exist" do
        post "/api/v1/users/non-existent-uuid/clients", 
             params: { id: client.id }.to_json, 
             headers: authenticated_headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User or Client not found')
      end

      it "returns 404 when client does not exist" do
        post "/api/v1/users/#{user.id}/clients", 
             params: { id: "non-existent-uuid" }.to_json, 
             headers: authenticated_headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('User or Client not found')
      end
    end

    context "when not authenticated" do
      let(:user) { FactoryBot.create(:user) }
      let(:client) { FactoryBot.create(:client, created_user: user) }

      it "returns 401 unauthorized" do
        post "/api/v1/users/#{user.id}/clients", 
             params: { id: client.id }.to_json, 
             headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end 