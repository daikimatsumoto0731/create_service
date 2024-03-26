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
          reply_message(event['replyToken'], '水やりの時間です！')
        end
      end
    end

    head :ok
  end

  private

  def line_bot_client
    @line_bot_client ||= Rails.application.config.line_bot_client
  end

  # LINEメッセージを返信する処理
  def reply_message(reply_token, text)
    message = {
      type: 'text',
      text:
    }
    line_bot_client.reply_message(reply_token, message)
  end
end
