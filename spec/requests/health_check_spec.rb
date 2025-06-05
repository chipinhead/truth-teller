require 'rails_helper'

RSpec.describe "Health Check", type: :request do
  describe "GET /up" do
    it "returns a 200 status code" do
      get "/up"
      expect(response).to have_http_status(:ok)
    end

    it "returns a success response" do
      get "/up"
      expect(response).to be_successful
    end
  end
end 