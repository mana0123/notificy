FactoryBot.define do
  require 'securerandom'

  factory :active_user, class: User do
    user_type { "room" }
    line_id { SecureRandom.hex(8) }
    status { 1 }
  end

  factory :inactive_user, class: User do
    user_type { "user" }
    line_id { SecureRandom.hex(8) }
    status { 0 }
  end


end
