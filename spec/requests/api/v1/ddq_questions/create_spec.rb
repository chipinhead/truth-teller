require 'rails_helper'

RSpec.describe "Api::V1::DdqQuestions", type: :request do
  describe "POST /api/v1/ddq_questions" do
    let(:user) { FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123') }
    let(:document) { FactoryBot.create(:document) }

    it "creates a ddq question when authenticated" do
      post "/api/v1/ddq_questions", 
           params: { 
             body: { 
               question: "Test question", 
               answer: "Test answer",
               document_id: document.id 
             } 
           }.to_json, 
           headers: authenticated_headers(user)

      expect(response).to have_http_status(:ok)
      binding.pry
      # json_response = json_attributes(response)
      # expect(json_response).to include(
      #   'question' => 'Test question',
      #   'answer' => 'Test answer',
      #   'document_id' => document.id
      # )
      # expect(json_response).to have_key('embedding')
      # expect(json_response['embedding']).to be_an(Array)
    end

    context "when not authenticated" do
      it "returns 401 unauthorized" do
        post "/api/v1/ddq_questions", 
             params: { 
               body: { 
                 question: "Test", 
                 answer: "Test answer",
                 document_id: 1 
               } 
             }, 
             headers: json_headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end 