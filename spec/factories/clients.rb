FactoryBot.define do
    factory :client do
      sequence(:name) { |n| "Client Name #{n}" }
      created_user { create(:user) }
    end
end