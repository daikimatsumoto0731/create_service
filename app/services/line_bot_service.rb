# frozen_string_literal: true

class LineBotService
  def self.send_push_message(line_user_id, message_text)
    client = Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_MESSAGING_API_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end

    message = {
      type: 'text',
      text: message_text
    }

    response = client.push_message(line_user_id, message)

    # レスポンスのステータスコードとボディをログに記録
    Rails.logger.info "Response Code: #{response.code}"
    Rails.logger.info "Response Body: #{response.body}"

    return unless response.code == '200'

    user = User.find_by(line_user_id:)
    return unless user

    user.notifications.create(message: message_text, sent_at: Time.current)
  end
end
