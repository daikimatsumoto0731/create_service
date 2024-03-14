class LineBotService
  def self.send_push_message(line_user_id, message_text)
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_MESSAGING_API_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  
    message = {
      type: 'text',
      text: message_text
    }
  
    response = client.push_message(line_user_id, message)
  
    # レスポンスのステータスコードとボディをログに記録
    Rails.logger.info "Response Code: #{response.code}"
    Rails.logger.info "Response Body: #{response.body}"
  
    if response.code == '200'
      user = User.find_by(line_user_id: line_user_id)
      if user
        user.notifications.create(message: message_text, sent_at: Time.current)
      end
    end
  end
end
  