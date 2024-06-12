FactoryBot.define do
  factory :event do
    title { "Sample Event" }
    start_date { Date.today }
    end_date { Date.today + 1.week }
    association :vegetable
  end
end
