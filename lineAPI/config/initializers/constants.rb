module Constants

  # scheduleAPIのURL
  SCHEDULE_API_URI = "http://api:3000/"

  LINE_API_URI = "https://api.line.me/"


  # LINEのチャネルシークレット
  File.open('/var/line/channel_seacret') do |file|
    file.each_line do |line|
      LINE_CHANNEL_SECRET = line.chomp
    end
  end


  # LINEのユーザID
  File.open('/var/line/user_id') do |file|
    file.each_line do |line|
      LINE_USER_ID = line.chomp
    end
  end

  # LINEのチャンネルID
  File.open('/var/line/channel_id') do |file|
    file.each_line do |line|
      LINE_CHANNEL_ID = line.chomp
    end
  end

# LINEのチャンネルアサーション署名キー
  str = ""
  Dir.glob("/var/line/assertion_signature_private_key/*") {|fname|
    File.open(fname) do |f|
      f.each_line do |line|
        str += line.chomp
      end
    end
  }
  LINE_ASSERTION_SIGN_KEY = str

  # LINEのチャンネルアクセストークン
  file = open('/var/line/access_token/latest/channel_access_token')
  lines = file.read().split("\n")
  LINE_CHANNEL_ACCESS_TOKEN_KEYID = lines[0]
  LINE_CHANNEL_ACCESS_TOKEN = lines[1]
  file.close

  if Rails.env == "production"
      ## 本番の定数
  else
      ## 開発の定数
  end
end
