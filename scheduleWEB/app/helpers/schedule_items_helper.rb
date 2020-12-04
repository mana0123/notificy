module ScheduleItemsHelper

  def schedule_item_date_format(date)
    year = date["year"].nil? ? "*" : date["year"]
    month = date["month"].nil? ? "*" : date["month"]
    day = date["day"].nil? ? "*" : date["day"]
    hour = date["hour"].nil? ? "*" : date["hour"]

    "#{year}/#{month}/#{day} #{hour}:00"
  end  

  def week_str(week)
    return "*" if week.nil?

    week_youbi = week/10 #1桁目
    week_dainan = week%10 #2桁目

    str = week_dainan == 0 ? "*" : "第#{week_dainan}"
    
    case week_youbi
      when 1 then str += "日曜日"
      when 2 then str += "月曜日"
      when 3 then str += "火曜日"
      when 4 then str += "水曜日"
      when 5 then str += "木曜日"
      when 6 then str += "金曜日"
      when 7 then str += "土曜日"
    end
    
  end

  def select_box_year
    year = {}
    for num in Date.today.year..Date.today.year+10 do
      year["#{num}"] = num
    end
    year
  end

  def select_box_month
    month = {}
    for num in 1..12 do
      month["#{num}"] = num
    end
    month
  end

  def select_box_day
    day = {}
    for num in 1..31 do
      day["#{num}"] = num
    end
    day
  end

  def select_box_hour
    hour = {}
    for num in 0..23 do
      hour["#{num}"] = num
    end
    hour
  end

end
