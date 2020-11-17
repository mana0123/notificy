require 'securerandom'

5.times do |n|
  User.create!( user_type: "room", line_id: SecureRandom.hex(8), status: 1)
  User.create!( user_type: "group", line_id: SecureRandom.hex(8), status: 1)
  User.create!( user_type: "user", line_id: SecureRandom.hex(8), status: 1)
  User.create!( user_type: "room", line_id: SecureRandom.hex(8), status: 0)
end

n = 1
User.all.each do |user|
  schedule_item = user.schedule_items.create!(
    status: 1,
    content: "レモたん#{n}号" )

  schedule_item.schedule_item_dates.create!(
    year: 2020,
    month: 1,
    week: nil,
    day: n%29 + 1,
    hour: 0)

  schedule_item.schedule_item_dates.create!(
    year: 2030,
    month: 1,
    week: nil,
    day: n%29 + 1,
    hour: 0)
  n = n + 1

end
