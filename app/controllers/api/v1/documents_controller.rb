module Api
  module V1
    class DocumentsController < ApplicationController
      before_action :authenticate_user!

      def index
        documents = Document.all
        render json: DocumentSerializer.new(documents, is_collection: true).serializable_hash, status: :ok
      end

      def create
        unless current_user.clients.exists?(document_data['client_id'])
          render json: { error: 'You do not have access to this client' }, status: :forbidden
          return
        end

        document = Document.new(document_data.merge(file: file_data))      

        if document.save
          document.reload
          render json: DocumentSerializer.new(document).serializable_hash, status: :created
        else
          render json: { errors: document.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Client not found' }, status: :not_found
      rescue JSON::ParserError
        render json: { errors: ['Invalid JSON format in document field'] }, status: :bad_request
      rescue ActionController::ParameterMissing => e
        render json: { error: 'File is required' }, status: :bad_request
      rescue StandardError => e
        render json: { errors: [e.message] }, status: :internal_server_error
      end

      private

      def document_data
        JSON.parse(params[:document])
      end

      def file_data
        params.require(:file)
      end
    end
  end
end 