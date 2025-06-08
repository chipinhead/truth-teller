class Client < ApplicationRecord
    # Associations
    belongs_to :created_user, class_name: 'User'
    has_and_belongs_to_many :users
    has_many :documents, dependent: :destroy
    
    # Validations
    validates :name, presence: true, uniqueness: true
end