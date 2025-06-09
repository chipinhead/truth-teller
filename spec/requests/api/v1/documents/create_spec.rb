require 'rails_helper'

RSpec.describe "Api::V1::Documents", type: :request do
  describe "POST /api/v1/documents" do
    context "when authenticated" do
      let(:user) { FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123') }
      let(:authorized_client) { FactoryBot.create(:client, created_user: user) }
      let(:unauthorized_client) { FactoryBot.create(:client, created_user: user) }
      let(:file) { fixture_file_upload('spec/fixtures/test_document.txt', 'text/plain') }
      
      let(:valid_document_json) do
        {
          client_id: authorized_client.id,
          source_id: "doc123",
          version: 1,
          title: "Test Document",
          metadata: { tags: ["important"] }
        }
      end

      before do
        # Associate user with authorized_client only
        user.clients << authorized_client
        # unauthorized_client is not associated with user
      end

      it "successfully creates a document with file when user has access to client" do
        expect {
          post "/api/v1/documents",
               params: {
                 document: valid_document_json.to_json,
                 file: file
               },
               headers: authenticated_headers(user).except('Content-Type')
        }.to change(Document, :count).by(1)

        expect(response).to have_http_status(:created)
        data = json_attributes(response)
        expect(data['title']).to eq(valid_document_json[:title])
        expect(data['source_id']).to eq(valid_document_json[:source_id])
        expect(data['version']).to eq(valid_document_json[:version])
        expect(data['file_url']).to be_present
      end

      it "returns 403 when user does not have access to client" do
        unauthorized_document_json = {
          client_id: unauthorized_client.id,
          source_id: "doc456",
          version: 1,
          title: "Unauthorized Document"
        }.to_json

        expect {
          post "/api/v1/documents", 
               params: { document: unauthorized_document_json },
               headers: authenticated_headers(user).except('Content-Type')
        }.not_to change(Document, :count)

        expect(response).to have_http_status(:forbidden)
        
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('You do not have access to this client')
      end

      it "returns error for invalid document data" do
        invalid_document_json = {
          client_id: authorized_client.id,
          source_id: "", # Invalid - empty
          version: 1,
          title: ""      # Invalid - empty
        }.to_json

        expect {
          post "/api/v1/documents",
               params: { document: invalid_document_json, file: file },
               headers: authenticated_headers(user).except('Content-Type')
        }.not_to change(Document, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include("Source can't be blank", "Title can't be blank")
      end

      it "returns error for invalid JSON format" do
        expect {
          post "/api/v1/documents",
               params: { document: "invalid json{" },
               headers: authenticated_headers(user).except('Content-Type')
        }.not_to change(Document, :count)

        expect(response).to have_http_status(:bad_request)
        
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include('Invalid JSON format in document field')
      end

      it "returns 400 bad request when file is missing" do
        expect {
          post "/api/v1/documents",
               params: { document: valid_document_json.to_json },
               headers: authenticated_headers(user).except('Content-Type')
        }.not_to change(Document, :count)

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when not authenticated" do
      let(:client) { FactoryBot.create(:client) }
      let(:document_json) do
        {
          client_id: client.id,
          source_id: "doc123",
          version: 1,
          title: "Test Document"
        }.to_json
      end

      it "returns 401 unauthorized" do
        post "/api/v1/documents", 
             params: { document: document_json }.to_json,
             headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end 