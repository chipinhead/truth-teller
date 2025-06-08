RSpec.describe "Api::V1::Clients", type: :request do
    describe "POST /api/v1/clients" do
        context "when authenticated" do
            let!(:user) { FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123') }
            let(:valid_client_params) { { client: { name: 'Test Client' } } }

            it "creates a new client" do
                post "/api/v1/clients", params: valid_client_params.to_json, headers: authenticated_headers
                expect(response).to have_http_status(:created)
            end
        end
    end
end