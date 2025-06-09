class DocumentSerializer
  include JSONAPI::Serializer
  
  attributes :source_id, :version, :title, :metadata, :file_url, :created_at, :updated_at  
end 