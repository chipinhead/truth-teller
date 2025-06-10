FactoryBot.define do
  factory :document_chunk do
    association :document
    sequence(:chunk_index) { |n| n }
    start { 0 }
    self.end { 100 }  # Using self.end because 'end' is a Ruby keyword
    sequence(:content) { |n| "Content for chunk #{n}" }
    token_count { 10 }
  end
end 