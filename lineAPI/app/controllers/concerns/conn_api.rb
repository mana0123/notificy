module ConnApi

  require 'net/http'
  require 'net/https'
  require 'uri'

  extend ActiveSupport::Concern

  # APIにHTTP接続するメソッド
  # api_srv : 接続先API　[:line, :schedule, :web_ap] 
  # path    : 接続先パス　string 
  # method  : HTTPメソッド　[:get, :post, :delete]
  # args    : リクエストパラメータがある場合は必須
  #          　:content_type ['application/x-www-form-urlencoded',
  #                          'application/json'] 
  #            :form_data ハッシュ
  #            :
  def send_api(api_srv, path, method, **args)
    case api_srv
      when :line
        domain = Constants::LINE_API_URI
      when :schedule
        domain = Constants::SCHEDULE_API_URI
      when :web_ap
        domain = Constants::WEB_AP_URI
    end
    
    url = URI.parse(domain + path)
    http = Net::HTTP.new(url.host, url.port)

    case method
      when :get then
        req = Net::HTTP::Get.new(url.path)
      when :post then
        req = Net::HTTP::Post.new(url.path)
      when :delete then
        req = Net::HTTP::Delete.new(url.path)
    end

    # LINE APIの場合、HTTPS通信
    if api_srv == :line
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req[:Authorization] = "Bearer " + Constants::LINE_CHANNEL_ACCESS_TOKEN
    end
    if args[:content_type] == 'application/x-www-form-urlencoded'
      req.content_type = 'application/x-www-form-urlencoded'
      req.set_form_data(args[:form_data]) unless args[:form_data].nil?
    elsif args[:content_type] == 'application/json'
      req.content_type = 'application/json'
      req.body = args[:form_data].to_json unless args[:form_data].nil?
    end

    if args[:headers]
      args[:headers].each do |k,v|
        req[k] = v
      end
    end

    Rails.logger.debug("start #{method} to #{:api_srv}_api\n to:#{url}\n param:#{req.body}\n")
    res = http.request(req)
    Rails.logger.debug("end #{method} to #{:api_srv}_api\n #{res.header}\n #{res.body}")
    res
  end
end
