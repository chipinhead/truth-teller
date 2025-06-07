# frozen_string_literal: true

Devise.setup do |config|
  # ==> JWT Configuration
  config.jwt do |jwt|
    # The secret key used by Devise-JWT to generate tokens
    # Use DEVISE_JWT_SECRET_KEY environment variable
    jwt.secret = ENV.fetch('DEVISE_JWT_SECRET_KEY') do
      raise 'DEVISE_JWT_SECRET_KEY environment variable is not set'
    end

    # How long a token is valid
    jwt.expiration_time = 1.day.to_i

    # Configure dispatch and revocation requests
    jwt.dispatch_requests = [
      ['POST', %r{^/users/sign_in$}],
      ['GET', %r{^/users/confirmation}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/users/sign_out$}]
    ]

    # The JWT signing algorithm to use
    jwt.request_formats = {
      user: [:json]
    }
  end
end 