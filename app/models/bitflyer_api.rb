class BitflyerApi < ApplicationRecord
  require 'net/http'
  require 'uri'
  require 'openssl'
  require 'json'

  class << self
    def call_api(method, uri, body="")
      key = ENV["BITFLYER_API_KEY"]
      secret = ENV["BITFLYER_API_SECRET"]

      timestamp = Time.now.to_i.to_s

      text = timestamp + method + uri.request_uri + body
      sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

      options = if method == "GET"
        Net::HTTP::Get.new(uri.request_uri, initheader = {
          "ACCESS-KEY" => key,
          "ACCESS-TIMESTAMP" => timestamp,
          "ACCESS-SIGN" => sign,
        });
      else
        Net::HTTP::Post.new(uri.request_uri, initheader = {
          "ACCESS-KEY" => key,
          "ACCESS-TIMESTAMP" => timestamp,
          "ACCESS-SIGN" => sign,
          # "Content-Type" => "application/json"
        });
      end
      options.body = body if body != ""

      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      response = https.request(options)

      return response.body
    end

    def ticker
      uri = URI.parse("https://api.bitflyer.jp")
      uri.path = "/v1/getticker"

      call_api("GET", uri)
    end
  end
end