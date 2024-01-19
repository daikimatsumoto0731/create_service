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
  
    response = self.class.post('/api/notify',
      body: {
       message: message
      }.to_json,
      headers: {
        'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{api_key}"
      }
    )
  
      # レスポンスの確認とエラーハンドリング
    handle_response(response)
  end
  
  private
  
  def handle_response(response)
    if response.code != 200
      Rails.logger.error("LINE API Error: #{response.body}")
    end
  end
end
  