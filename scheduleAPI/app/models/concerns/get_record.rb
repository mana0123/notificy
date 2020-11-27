module GetRecord
  extend ActiveSupport::Concern

  def select_schedule_items_join_date(**where)
    schedule_items = []
    ScheduleItem.eager_load(:schedule_item_dates)
                .where(where).each do |schedule_item|
      schedule_items << {schedule_item: schedule_item,
                        schedule_item_dates: schedule_item.schedule_item_dates}
    end
    schedule_items
  end

  def select_users_join_schedule_items_and_date(**where)
    items = []
    ScheduleItemDate.eager_load(schedule_item: :user)
       .where(where).each do |date|
      items << { user: date.schedule_item.user, schedule_item: date.schedule_item, schedule_item_date: date }
    end
    items
  end

end
