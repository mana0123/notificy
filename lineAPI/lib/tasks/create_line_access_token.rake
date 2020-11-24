namespace :create_line_access_token do

  desc "チャンネルアクセストークンの発行"
  task create: :environment do
    include ConnApi
    require 'time'
    require 'json/jwt'

    root_path = '/var/line/access_token/'
    latest_file = root_path + 'latest/channel_access_token'
    old_path = root_path + 'old/channel_access_token'
    
    # 既存のファイルが存在する場合は、oldフォルダに退避する
    if File.exist?(latest_file)
      old_file = old_path + "." + Date.today.strftime("%Y%m%d")
      File.rename(latest_file, old_file)
    end

    # JWTの生成
    jwk = JSON.parse(Constants::LINE_ASSERTION_SIGN_KEY)

    payload = { iss: Constants::LINE_CHANNEL_ID, 
                sub: Constants::LINE_CHANNEL_ID,
                aud: "https://api.line.me/",
                exp: Time.now.to_i + 60 * 30,
                token_exp: 60 * 60 * 24 * 30 }

    header = { alg: "RS256",
               typ: "JWT",
               kid: jwk["kid"] }

    jwt = JSON::JWT.new(payload)
    jwt.header = header

    private_key = JSON::JWK.new(jwk).to_key
    jws = jwt.sign(private_key).to_s

    post_data = {grant_type: 'client_credentials', 
                 client_assertion_type: 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer', 
                 client_assertion: jws }

    # チャンネルアクセストークンの取得
    res = send_api(:line, 'oauth2/v2.1/token', :post, content_type: 'application/x-www-form-urlencoded', form_data: post_data)
    res_json = JSON.parse(res.body)

    # ファイル作成
    open(latest_file, 'w'){|f|
      f.write(res_json['key_id'] + "\n")
      f.write(res_json['access_token'])
    }

  end
end
