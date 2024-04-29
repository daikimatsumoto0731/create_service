# frozen_string_literal: true

class LineBotService
  def self.send_weather_message(line_user_id, weather_data)
    message_text = determine_message(weather_data)
    send_push_message(line_user_id, message_text)
  end

  private

  def self.client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_MESSAGING_API_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
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
    messages = [message]
    response = client.push_message(line_user_id, messages: messages) # メッセージをHashのキーとして渡す
    Rails.logger.info "Sending message to user ID: #{line_user_id}, Message: #{message_text}"
    handle_response(response, line_user_id, message_text)
  end  

  def self.handle_response(response, line_user_id, message_text)
    Rails.logger.info "Response Code: #{response.code}, Response Body: #{response.body}"

    if response.code.to_s == '200'
      Rails.logger.info "Message sent successfully to user ID: #{line_user_id}"
      
      if (user = User.find_by(line_user_id: line_user_id))
        user.notifications.create(message: message_text, sent_at: Time.current)
      end
    else
      Rails.logger.error "Failed to send message to user ID: #{line_user_id}, Error: #{response.body}"
    end
  rescue => e
    Rails.logger.error "Exception occurred while sending message to user ID: #{line_user_id}: #{e.message}"
  end
end
