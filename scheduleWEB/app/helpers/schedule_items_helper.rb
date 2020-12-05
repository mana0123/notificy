module ScheduleItemsHelper

  def schedule_item_date_format(date)
    year = date["year"].nil? ? "*" : date["year"]
    month = date["month"].nil? ? "*" : date["month"]
    day = date["day"].nil? ? "*" : date["day"]
    hour = date["hour"].nil? ? "*" : date["hour"]

    "#{year}/#{month}/#{day} #{hour}:00"
  end  

  # weekの数字を文字列化する
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

  def select_box_dainan
    { "第1": 1, "第2": 2, "第3": 3 ,"第4": 4 }
  end

  def select_box_week
    { "日": 1, "月": 2, "火": 3 ,"水": 4, "木": 5, "金": 6, "土": 7 }
  end

  # 固定日かどうか
  def date_type_fixed?(date)
    !date[:year].nil?
  end

  def format_date_to_full_str(date)
    format("%04d-%02d-%02d", date[:year], date[:month], date[:day])
  end

  # rooped_typeを返す
  def judge_rooped_type(date)
    week = format_week_to_split(date[:week])
    if date[:month] && date[:day] && date[:hour]
      1
    elsif ( date[:day] && date[:hour] ) ||
          ( date[:week] && week[:dainan] && date[:hour] )
      2
    elsif date[:week] && date[:hour]
      3
    elsif date[:hour]
      4
    else
      5
    end
  end

  # week(2桁)をweek(曜日)とdainan(第何曜日)に分ける
  def format_week_to_split(week)
    return nil if week.nil?
    { week: week/10, dainan: week%10 }
  end
end
