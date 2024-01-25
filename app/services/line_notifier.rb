class LineNotifier
  include HTTParty
  base_uri 'https://notify-api.line.me'
  
  def initialize(user)
    @user = user
  end
  
  def send_message(message)
    return unless @user.line_notification_setting&.receive_notifications
  
    # アクセストークンを環境変数から取得
    api_key = ENV['LINE_NOTIFY_API_KEY']
    unless api_key
      Rails.logger.error("LINE_NOTIFY_API_KEY is not set.")
      return
    end
  
    response = self.class.post('/api/notify',
      body: {
        message: message
      }.to_json,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{api_key}"
      }
    )
  
    handle_response(response)
  end
  
  private
  
  def handle_response(response)
    if response.code == 200
      Rails.logger.info("LINE notification sent successfully.")
    else
      Rails.logger.error("LINE API Error: Status: #{response.code}, Response: #{response.body}")
    end
  end
end
