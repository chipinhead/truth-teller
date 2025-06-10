class Document < ApplicationRecord
  include Shrine::Attachment(:file)
  belongs_to :client
  has_many :document_chunks, dependent: :destroy

  validates :source_id, presence: true
  validates :version, presence: true, numericality: { greater_than: 0 }
  validates :title, presence: true
  validates :client, presence: true
  validates :source_id, uniqueness: { scope: [:client_id, :version] }

  # Callbacks
  after_commit :chunk_document, on: [:create, :update], if: :should_chunk_document?

  private

  def should_chunk_document?
    # Only chunk if file_data changed and we don't have any chunks yet
    saved_change_to_file_data? && document_chunks.none?
  end

  def chunk_document
    ChunkDocumentJob.perform_later(id)
  end
end 