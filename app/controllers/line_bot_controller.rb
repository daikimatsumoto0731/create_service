# frozen_string_literal: true

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
        handle_message_event(event)
      when Line::Bot::Event::Follow
        handle_follow_event(event)
      end
    end

    head :ok
  end

  private

  def line_bot_client
    @line_bot_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  # LINEメッセージを受信したときの処理
  def handle_message_event(event)
    case event.type
    when Line::Bot::Event::MessageType::Text
      reply_message(event['replyToken'], '水やりの時間です！')
    end
  end

  # ユーザーが友達追加したときのイベントを処理する
  def handle_follow_event(event)
    user_id = event['source']['userId']
    User.find_or_create_by(line_user_id: user_id)  # ユーザーIDをデータベースに保存する処理
    reply_message(event['replyToken'], "友達登録ありがとうございます！")
  end

  # LINEメッセージを返信する処理
  def reply_message(reply_token, text)
    message = {
      type: 'text',
      text: text
    }
    line_bot_client.reply_message(reply_token, message)
  end
end
