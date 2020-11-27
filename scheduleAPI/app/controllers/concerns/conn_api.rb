module ConnApi

  require 'net/http'
  require 'uri'
  extend ActiveSupport::Concern

  def send_line_api(path, method, **args)
    url = URI.parse(Constants::LINE_API_URI + path)
    case method
    when :get then
      req = Net::HTTP::Get.new(url.path)
    when :post then
      req = Net::HTTP::Post.new(url.path)
      req.content_type = 'application/json'
      req.body = args[:form_data].to_json
    when :delete then
      req = Net::HTTP::Delete.new(url.path)
    end
    Rails.logger.debug("start #{method} to line_api\n to:#{url}\n param:#{req.body}\n")
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    Rails.logger.debug("end #{method} to line_api\n #{res.header}\n #{res.body}")
    res
  end
end
