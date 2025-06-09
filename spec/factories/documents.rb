FactoryBot.define do
  factory :document do
    sequence(:source_id) { |n| "source_#{n}" }
    version { 1 }
    sequence(:title) { |n| "Document Title #{n}" }
    storage_path { nil }
    metadata { { tags: ["test"] } }
    
    association :client
  end
end 