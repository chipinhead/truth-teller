class User < ApplicationRecord
  # Include devise modules (database_authenticatable, registerable, recoverable, rememberable, confirmable, lockable, and trackable) and devise-jwt (with denylist revocation strategy) for API authentication.
  devise :database_authenticatable,
         :registerable,
         :confirmable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  # Associations
  has_and_belongs_to_many :clients
  has_many :created_clients, class_name: 'Client', foreign_key: 'created_user_id'

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
end
