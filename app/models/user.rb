class User < ApplicationRecord
  # Include devise modules (database_authenticatable, registerable, recoverable, rememberable, confirmable, lockable, and trackable) and devise-jwt (with denylist revocation strategy) for API authentication.
  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  # (Optional) Add any additional validations or custom logic here.
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
end
