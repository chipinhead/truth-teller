class Client < ApplicationRecord
    belongs_to :created_user, class_name: 'User'
    validates :name, presence: true, uniqueness: true
end