module Constants

  LINE_API_URI = "http://line_api:3040/"

  if Rails.env == "production"
      ## 本番の定数
  else
      ## 開発の定数
  end
end
