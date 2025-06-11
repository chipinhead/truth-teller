module Api
  module V1
    class DdqQuestionsController < ApplicationController
      #before_action :authenticate_user!

      def create
        context = get_context(question_params[:question])
        client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
        ddq_service = DdqService.new(client)
        response = evaluate_answer(context, question_params[:question], question_params[:answer])
        
        render json: { 
          data: {
            question: question_params[:question],
            answer: question_params[:answer],
            analysis: response
          }
        }
      end

      private

      def get_context(question)
        similar_chunks = DocumentChunk.similarity_search(question).limit(5)
        context = similar_chunks.map(&:content).join("\n\n")
        context
      end

      def evaluate_answer(context, question, answer)
        client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
        ddq_service = DdqService.new(client)
        response = ddq_service.evaluate_answer(context, question, answer)
        response
      end

      def question_params
        params.permit(:question, :answer, :document_id)
      end
    end
  end
end