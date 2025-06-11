namespace :ddq do
  desc "Generate embeddings for a hardcoded DDQ question and find similar document chunks"
  task test_qa: :environment do
    # Hardcoded test data
    question = "Please describe the Fund's investment policy and any key investment restrictions."
    answer = " The Fund has significant flexibility in its investment strategy. It can invest up to 50% of the aggregate Commitments in a single portfolio company, has no strict limitations on investing in Portfolio Companies outside of the Target Region, and may invest in speculative opportunities or companies that charge a fee or profit share without requiring prior written consent of the Advisory Committee"
    document_id = "0bec099a-0f52-4289-b3e3-3ebc14cbca08"

    puts "\nSearching for similar document chunks for question:"
    puts "Question: #{question}"
    puts "Answer: #{answer}"
    puts "Document ID: #{document_id}"

    begin
      puts "\nSearching for similar document chunks..."
      similar_chunks = DocumentChunk.similarity_search(question).limit(5)
      
      puts "\nTop 5 similar document chunks found:"
      similar_chunks.each_with_index do |chunk, index|
        puts "\n#{index + 1}. Chunk #{chunk.chunk_index} (Document: #{chunk.document_id})"
        puts "Content: #{chunk.content[0..200]}..." # Show first 200 chars
        puts "Start position: #{chunk.start}, End position: #{chunk.end}"
      end

      # Combine chunks into context and evaluate the answer
      context = similar_chunks.map(&:content).join("\n\n")
      
      puts "\nEvaluating answer with GPT-4..."
      client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
      ddq_service = DdqService.new(client)
      evaluation_response = ddq_service.evaluate_answer(context, question, answer)
      
      puts "\nEvaluation Result:"
      puts evaluation_response

    rescue => e
      puts "\nError occurred:"
      puts e.message
      puts e.backtrace
    end
  end
end 