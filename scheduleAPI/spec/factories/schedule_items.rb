FactoryBot.define do

  sequence :content_seq do |i|
    "レモタン #{i}号"
  end

  factory :schedule_item do
    status { 1 }
    content { generate :content_seq }

    association :user,
      factory: :active_user

  end
end
