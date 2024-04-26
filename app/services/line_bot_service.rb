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
    "今日の天気に関係なく、水やりの状況を確認してください。"
  end  

  def self.send_push_message(line_user_id, message_text)
    message = { type: 'text', text: message_text }
    response = client.push_message(line_user_id, message)
    Rails.logger.info "Response Code: #{response.code}"
    Rails.logger.info "Response Body: #{response.body}"
    handle_response(response, line_user_id, message_text)
  end

  def self.handle_response(response, line_user_id, message_text)
    Rails.logger.info "Response Code: #{response.code}, Response Body: #{response.body}"
    return unless response.code.to_s == '200'  # 応答コードの比較を文字列として行う
  
    if (user = User.find_by(line_user_id: line_user_id))
      user.notifications.create(message: message_text, sent_at: Time.current)
    end
  rescue => e
    Rails.logger.error "Failed to send message: #{e.message}, Response Code: #{response.code}"
  end
end