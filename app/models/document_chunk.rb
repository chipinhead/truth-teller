class DocumentChunk < ApplicationRecord
  vectorsearch
  belongs_to :document
  after_commit :generate_embedding, on: [:create, :update]

  # Validations
  validates :chunk_index, presence: true, uniqueness: { scope: :document_id }
  validates :start, presence: true, numericality: { only_integer: true }
  validates :end, presence: true, numericality: { only_integer: true }
  validates :content, presence: true
  #validates :token_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :embedding_model, presence: true, if: :embedding?

  # Callbacks
  private

  def generate_embedding
    GenerateDocumentChunkEmbeddingJob.perform_later(id)
  end

  # Override the default vector representation to only use content
  def as_vector
    content
  end
end 