class GenerateDocumentChunkEmbeddingJob < ApplicationJob
  queue_as :default

  def perform(document_chunk_id)
    document_chunk = DocumentChunk.find_by(id: document_chunk_id)
    return unless document_chunk

    # Use the built-in upsert_to_vectorsearch method
    document_chunk.upsert_to_vectorsearch
  rescue ActiveRecord::RecordNotFound
    # Document chunk was deleted, nothing to do
  rescue StandardError => e
    # Log the error and re-raise to trigger retry
    Rails.logger.error("Failed to generate embedding for DocumentChunk ##{document_chunk_id}: #{e.message}")
    raise
  end
end 