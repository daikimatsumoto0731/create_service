class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  # LINE Botがメッセージを受信したときの処理
  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless line_bot_client.validate_signature(body, signature)
      head :bad_request
      return
    end

    events = line_bot_client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: '水やりの時間です！'
          }
          line_bot_client.reply_message(event['replyToken'], message)
        end
      end
    end

    head :ok
  end

  private

  def line_bot_client
    @line_bot_client ||= Rails.application.config.line_bot_client
  end
end