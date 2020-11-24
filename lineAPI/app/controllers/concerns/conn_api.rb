module ConnApi

  require 'net/http'
  require 'net/https'
  require 'uri'

  extend ActiveSupport::Concern

  # APIにHTTP接続するメソッド
  # api_srv : 接続先API　[:line, :schedule] 
  # path    : 接続先パス　string 
  # method  : HTTPメソッド　[:get, :post, :delete]
  # args    : リクエストパラメータがある場合は必須
  #          　:content_type ['application/x-www-form-urlencoded',
  #                          'application/json'] 
  #            :form_data ハッシュ
  def send_api(api_srv, path, method, **args)
    case api_srv
      when :line
        domain = Constants::LINE_API_URI
      when :schedule
        domain = Constants::SCHEDULE_API_URI
    end
    
    url = URI.parse(domain + path)
    http = Net::HTTP.new(url.host, url.port)

    # LINE APIの場合、HTTPS通信
    if api_srv == :line
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    case method
      when :get then
        req = Net::HTTP::Get.new(url.path)
      when :post then
        req = Net::HTTP::Post.new(url.path)
      when :delete then
        req = Net::HTTP::Delete.new(url.path)
    end

    if args[:content_type] == 'application/x-www-form-urlencoded'
      req.content_type = 'application/x-www-form-urlencoded'
      req.set_form_data(args[:form_data])
    elsif args[:content_type] == 'application/json'
      req.content_type = 'application/json'
      req.body = args[:form_data].to_json
    end

    Rails.logger.debug("start #{method} to schedule_api\n to:#{url}\n param:#{req.body}\n")
    res = http.request(req)
    Rails.logger.debug("end #{method} to schedule_api\n #{res.header}\n #{res.body}")
    res
  end
end
