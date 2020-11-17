module Constants

  # scheduleAPIのURL
  SCHEDULE_API_URI = "http://api:3000/"

  # LINEのチャネルシークレット
  File.open('config/line.key') do |file|
    file.each_line do |line|
      LINE_CHANNEL_SECRET = line.chomp
    end
  end


  if Rails.env == "production"
      ## 本番の定数
  else
      ## 開発の定数
  end
end
