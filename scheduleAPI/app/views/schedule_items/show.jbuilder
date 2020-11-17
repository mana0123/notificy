json.schedule_item do
  json.extract! @schedule_item[:schedule_item], :id, :content, :status
  json.date do
    json.array! @schedule_item[:schedule_item_dates],
                :year, :month, :week, :day, :hour
  end
end
