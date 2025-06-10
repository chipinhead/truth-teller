module LLMHelpers
  def stub_llm_embedding
    @fake_embedding = Array.new(1536) { rand(-1.0..1.0) }
    llm = LangchainrbRails.config.vectorsearch.llm
    allow(llm).to receive(:embed).and_return(double(embedding: @fake_embedding))
    @fake_embedding
  end

  def fake_embedding
    @fake_embedding
  end
end 