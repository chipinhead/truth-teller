module AuthenticationHelpers
  def authenticate_user(user = nil)
    user ||= create_test_user
    
    post "/users/sign_in", params: {
      user: {
        email: user.email,
        password: 'password123'
      }
    }.to_json, headers: { 'Content-Type' => 'application/json' }
    
    response.headers['Authorization']
  end

  def authenticated_headers(user = nil)
    {
      'Authorization' => authenticate_user(user),
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  def json_headers
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  private

  def create_test_user
    FactoryBot.create(:user, password: 'password123', password_confirmation: 'password123')
  end
end 