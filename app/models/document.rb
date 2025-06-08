class Document < ApplicationRecord
  belongs_to :client
  has_one_attached :file

  validates :source_id, presence: true
  validates :version, presence: true, numericality: { greater_than: 0 }
  validates :title, presence: true
  validates :client, presence: true
  validates :source_id, uniqueness: { scope: [:client_id, :version] }
end 