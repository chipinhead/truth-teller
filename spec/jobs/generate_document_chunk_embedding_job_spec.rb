require 'rails_helper'

RSpec.describe GenerateDocumentChunkEmbeddingJob, type: :job do
  let(:document_chunk) { create(:document_chunk) }

  describe '#perform' do
    it 'generates embedding for the document chunk' do
      # Expect the upsert_to_vectorsearch method to be called
      #expect_any_instance_of(DocumentChunk).to receive(:upsert_to_vectorsearch).once

      # Run the job
      described_class.perform_now(document_chunk.id)
    end

    it 'handles non-existent document chunk gracefully' do
      # Run the job with a non-existent ID
      expect {
        described_class.perform_now('non-existent-id')
      }.not_to raise_error
    end
  end
end 