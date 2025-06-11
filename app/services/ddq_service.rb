class DdqService
  PROMPTS_PATH = Rails.root.join("config", "prompts", "ddq_evaluation.yaml")

  def initialize(client)
    @client = client
    @prompts = YAML.load_file(PROMPTS_PATH).dig("prompts")
  end

  def evaluate_answer(context, question, answer)
    prompts = @prompts["ddq_evaluation"]
    messages = [
      { role: prompts["system"]["role"], content: prompts["system"]["content"] },
      { 
        role: prompts["human"]["role"], 
        content: format(prompts["human"]["template"], 
          question: question,
          answer: answer,
          context: context
        )
      }
    ]

    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: messages,
        temperature: 0.0  
      }
    )

    response.dig("choices", 0, "message", "content")
  end

  def parse_qa(contents)
    prompts = @prompts["ddq_parse"]
    messages = [
      { role: prompts["system"]["role"], content: prompts["system"]["content"] },
      { role: prompts["human"]["role"], content: format(prompts["human"]["template"], qanda: contents) }
    ]
    response = @client.chat(
      parameters: {
          model: "gpt-4o-mini",
          messages: messages,
          temperature: 0.0  
      }
    )
    result = response.dig("choices", 0, "message", "content")
    JSON.parse(result)
  end
end 