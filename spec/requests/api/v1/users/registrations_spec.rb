require 'rails_helper'

RSpec.describe "Api::V1::Users::Registrations", type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' } }

  describe "POST /users" do
    let(:valid_attributes) do
      {
        user: FactoryBot.attributes_for(:user).merge(
          password: 'password123',
          password_confirmation: 'password123'
        )
      }
    end

    it "creates a new user and sends confirmation email" do
      expect {
        post "/users", params: valid_attributes.to_json, headers: headers
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Signed up.')
      expect(json_response['user']).to include('email' => valid_attributes[:user][:email])
      expect(json_response['user']).to include('name' => valid_attributes[:user][:name])
      expect(json_response['user']).to include('id')

      user = User.last
      expect(user.email).to eq(valid_attributes[:user][:email])
      expect(user.name).to eq(valid_attributes[:user][:name])
    end

    it "sends confirmation instructions via background job" do
      user_spy = spy('user')
      allow(User).to receive(:find).and_return(user_spy)
      allow(user_spy).to receive(:send_confirmation_instructions)

      post "/users", params: valid_attributes.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(user_spy).to have_received(:send_confirmation_instructions)
    end
  end
end 