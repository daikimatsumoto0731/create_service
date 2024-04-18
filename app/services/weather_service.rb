require 'net/http'
require 'uri'
require 'json'
require 'cgi' # CGI.escapeを使用するために必要

class WeatherService
  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

  # 特定の都市の天気情報を取得するクラスメゾット
  def self.fetch_weather(city)
    # CGI.escapeを使用して都市名をエンコード
    escaped_city = CGI.escape(city)
    uri = URI("#{BASE_URL}?q=#{escaped_city}&appid=#{ENV['OPENWEATHER_API_KEY']}&units=metric")

    # APIリクエストのエラーハンドリング
    begin
      response = Net::HTTP.get(uri)
      JSON.parse(response)
    rescue StandardError => e
      # エラーロギングや別のエラー対応をここに記述
      { error: "Failed to fetch weather data: #{e.message}" }
    end
  end
end
