class Client < ApplicationRecord
    belongs_to :created_user, class_name: 'User'
    has_many :documents, dependent: :destroy
    
    validates :name, presence: true, uniqueness: true
end