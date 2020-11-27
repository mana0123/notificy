namespace :notify_schedule do
  task run: :environment do
    include ConnApi
    include GetRecord
    require 'time'
    t = Time.now.in_time_zone('Tokyo')
    where = { schedule_item_dates:
              { year: [t.year, nil], month: [t.month, nil], 
               day: [t.day, nil], hour: [t.hour, nil],
               week: [ScheduleItemDate.date_to_week(t), nil] },
              users: {status: 1} }
    items = select_users_join_schedule_items_and_date(where)
    items.each do |item|
      form_data = { to: item[:user][:line_id], messages: [{ type: "text", text: item[:schedule_item][:content] } ] }
      send_line_api("send_line/messages", :post, form_data: form_data)
    end
  end
end
