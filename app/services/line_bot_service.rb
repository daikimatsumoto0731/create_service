# frozen_string_literal: true

class LineBotService
  def self.send_daily_weather_message
    # 天気データを取得
    weather_data = fetch_weather_data
    message_text = determine_message(weather_data)

    # データベースに保存されているすべてのユーザーに対してメッセージを送信
    User.find_each do |user|
      send_push_message(user.line_user_id, message_text) if user.line_user_id.present?
    end
  end

  private

  def self.fetch_weather_data
    # 天気APIからデータを取得
    {
      "weather" => [{"main" => "Rain", "description" => "light rain"}],
      "main" => {"temp" => 16}
    }
  end

  def self.determine_message(weather_data)
    if weather_data["weather"] && weather_data["weather"][0]["main"] == "Rain"
      "今日は雨が降っています。水やりは控えめにしてください。"
    else
      description = weather_data.dig("weather", 0, "description") || "晴れ"
      "今日の天気は#{description}です。水やりをお忘れなく！"
    end
  end  

  def self.send_push_message(line_user_id, message_text)
    message = { type: 'text', text: message_text }
    client = line_bot_client
    response = client.push_message(line_user_id, [message])
    handle_response(response, line_user_id, message_text)
  end  

  def self.line_bot_client
    @line_bot_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_MESSAGING_API_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def self.handle_response(response, line_user_id, message_text)
    Rails.logger.info "Response Code: #{response.code}, Response Body: #{response.body}"
    if response.code.to_s == '200'
      Rails.logger.info "Message sent successfully to user ID: #{line_user_id}"
    else
      Rails.logger.error "Failed to send message to user ID: #{line_user_id}, Error: #{response.body}"
    end
  rescue => e
    Rails.logger.error "Exception occurred while sending message to user ID: #{line_user_id}: #{e.message}"
  end
end
