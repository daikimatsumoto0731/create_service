require 'net/http'
require 'uri'
require 'json'
require 'cgi' # CGI.escapeを使用するために必要

class WeatherService
  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"
  @@client = Net::HTTP.new(URI(BASE_URL).host, URI(BASE_URL).port)
  @@client.use_ssl = true
  
  # 特定の都市の天気情報を取得するクラスメソッド
  def self.fetch_weather(city)
    escaped_city = CGI.escape(city)
    uri = URI("#{BASE_URL}?q=#{escaped_city}&appid=#{ENV['OPENWEATHER_API_KEY']}&units=metric&lang=ja")  # 日本語のレスポンスを指定
  
    # APIリクエストのエラーハンドリング
    begin
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "application/json"
  
      response = @@client.request(request)
      case response
      when Net::HTTPSuccess then
        JSON.parse(response.body)
      else
        # 他のHTTPエラーを適切にハンドル
        { error: "HTTP Error: #{response.code} #{response.message}" }
      end
    rescue StandardError => e
      # エラーロギングや別のエラー対応をここに記述
      { error: "Failed to fetch weather data: #{e.message}" }
    end
  end
end
  