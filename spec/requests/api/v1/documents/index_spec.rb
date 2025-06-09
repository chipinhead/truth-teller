require 'rails_helper'

RSpec.describe "Api::V1::Documents", type: :request do
  describe "GET /api/v1/documents" do
    context "when authenticated" do
      let(:user) { FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123') }
      let(:client) { FactoryBot.create(:client, created_user: user) }
      let!(:documents) { FactoryBot.create_list(:document, 2, client: client) }

      before do
        # Associate user with client so they can see documents
        user.clients << client
      end

      it "returns a list of documents with file URLs" do
        get "/api/v1/documents", headers: authenticated_headers

        expect(response).to have_http_status(:ok)
        
        data = json_attributes(response)
        expect(data.length).to eq(documents.length)
        expect(data.map { |d| d['title'] }).to match_array(documents.map(&:title))
      end
    end

    context "when not authenticated" do
      it "returns 401 unauthorized" do
        get "/api/v1/documents", headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end 