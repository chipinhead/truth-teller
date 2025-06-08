module Api
  module V1
    class DocumentsController < ApplicationController
      before_action :authenticate_user!

      def index
        documents = Document.all
        render json: documents.map { |doc| document_with_file_url(doc) }, status: :ok
      end

      def create
        document = Document.new(document_data)        
        document.file.attach(file_data)
        
        if document.save
          render json: document_with_file_url(document), status: :created
        else
          render json: { errors: document.errors.full_messages }, status: :unprocessable_entity
        end
      rescue JSON::ParserError
        render json: { errors: ['Invalid JSON format in document field'] }, status: :bad_request
      end

      private

      def document_data
        JSON.parse(params[:document])
      end

      def file_data
        params.require(:file)
      end

      def document_with_file_url(document)
        doc_json = document.as_json
        doc_json['file_url'] = document.file.attached? ? url_for(document.file) : nil
        doc_json['file_name'] = document.file.attached? ? document.file.filename.to_s : nil
        doc_json
      end
    end
  end
end 