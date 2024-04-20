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
    main_weather = weather_data['weather'][0]['main']
    case main_weather
    when 'Rain'
      "今日は雨が降っています。水やりは不要ですね！"
    when 'Clear'
      "今日は晴れです。水やりを頑張りましょう！"
    when 'Clouds'
      "今日は曇りですが、水やりを忘れずに！"
    else
      "今日の天気: #{main_weather}。水やりの状況を確認してください。"
    end
  end

  def self.send_push_message(line_user_id, message_text)
    message = { type: 'text', text: message_text }
    response = client.push_message(line_user_id, message)
    Rails.logger.info "Response Code: #{response.code}"
    Rails.logger.info "Response Body: #{response.body}"
    handle_response(response, line_user_id, message_text)
  end

  def self.handle_response(response, line_user_id, message_text)
    return unless response.code == '200'
    if (user = User.find_by(line_user_id: line_user_id))
      user.notifications.create(message: message_text, sent_at: Time.current)
    end
  rescue => e
    Rails.logger.error "Failed to send message: #{e.message}"
  end
end
