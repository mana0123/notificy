module Constants

  SCHEDULE_API_URI = "http://api:3000/"

  if Rails.env == "production"
      ## 本番の定数
  else
      ## 開発の定数
  end
end
