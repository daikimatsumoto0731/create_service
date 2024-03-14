class LineBotService
  def self.send_push_message(line_user_id, message_text)
    # LINEクライアントの設定
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_MESSAGING_API_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
    
    # メッセージの内容
    message = {
      type: 'text',
      text: message_text
    }
  
    # メッセージの送信
    response = client.push_message(line_user_id, message)
  
    # メッセージ送信成功時に通知履歴を記録
    if response.code == 200
      user = User.find_by(line_user_id: line_user_id)
      if user
        user.notifications.create(message: message_text, sent_at: Time.current)
      end
    end
  end
end
  