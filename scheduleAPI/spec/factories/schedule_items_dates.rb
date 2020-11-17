FactoryBot.define do

  sequence :num_seq do |i|
    if i%28 == 0
      1
    else
      i%28
    end
  end

  factory :schedule_item_date do
    year { 2020 }
    month { 10 }
    week { nil }
    day { generate(:num_seq) }
    hour { 0 }

    association :schedule_item,
      factory: :schedule_item
  
  end



end
