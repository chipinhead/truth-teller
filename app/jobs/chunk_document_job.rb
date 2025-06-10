class ChunkDocumentJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    
    document = Document.find_by(id: document_id)
    return unless document&.file_url

    # Read the content from the file
    
    file_path = Rails.root.join("storage", document.file_url[1..])
    return unless File.exist?(file_path)

    content = File.read(file_path)
    return if content.blank?

    # Initialize the text splitter
    text_splitter = Langchain::Chunker::RecursiveText.new(
      content,
      chunk_size: 3096,
      chunk_overlap: 128,
      separators: ["\n\n", "\n", ".", "!", "?", " ", ""] 
    )

    # Split the content into chunks
    chunks = text_splitter.chunks.map(&:text)
    
    # Create document chunks with positions
    chunks.each_with_index do |chunk, index|
      start_pos = index * (3096 - 128)  
      end_pos = start_pos + chunk.length
      DocumentChunk.create!(
        document: document,
        chunk_index: index,
        start: start_pos,
        end: end_pos,
        content: chunk,
        token_count: 0
      )
    end
  rescue ActiveRecord::RecordNotFound
    # Document was deleted, nothing to do
  rescue StandardError => e
    # Log the error and re-raise to trigger retry
    Rails.logger.error("Failed to chunk Document ##{document_id}: #{e.message}")
    raise
  end
end 