json.messages @messages

json.schedule_items @schedule_items do |schedule_item|
  json.extract! schedule_item[:schedule_item], :id, :content, :status
  json.dates do
    json.array! schedule_item[:schedule_item_dates],
                :year, :month, :week, :day, :hour
  end
end
