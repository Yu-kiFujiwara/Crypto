class CoincheckApi < ApplicationRecord
  require 'net/http'
  require 'uri'
  require 'openssl'
  class << self
    def data
      key = ENV["COINCHECK_API_KEY"]
      secret = ENV["COINCHECK_API_SECRET"]
      uri = URI.parse "https://coincheck.com/api/ticker"
      nonce = Time.now.to_i.to_s
      message = nonce + uri.to_s
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, message)
      headers = {
        "ACCESS-KEY" => key,
        "ACCESS-NONCE" => nonce,
        "ACCESS-SIGNATURE" => signature
      }
      access(headers, uri)
    end

    def access(headers, uri)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      response = https.start {
        https.get(uri.request_uri, headers)
      }

      return response.body
    end
  end
end