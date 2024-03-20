# frozen_string_literal: true

class LineNotifier
  include HTTParty
  base_uri 'https://notify-api.line.me'

  def initialize(access_token)
    @access_token = access_token
  end

  def send_message(message)
    # リクエストヘッダにAuthorizationを設定
    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{@access_token}"
    }

    # 通知メッセージを設定
    body = {
      message:
    }

    # LINE Notify APIにPOSTリクエストを送信
    response = self.class.post('/api/notify', headers:, body:)

    # レスポンスの処理
    handle_response(response)
  end

  private

  def handle_response(response)
    case response.code
    when 200
      Rails.logger.info('LINE notification sent successfully.')
    when 400
      Rails.logger.error("Bad Request: #{response.body}")
    when 401
      Rails.logger.error("Unauthorized: #{response.body}")
    when 500
      Rails.logger.error("Internal Server Error: #{response.body}")
    else
      Rails.logger.error("Unknown Error: #{response.body}")
    end
  end
end
