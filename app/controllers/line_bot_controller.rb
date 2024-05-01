# frozen_string_literal: true

class LineBotController < ApplicationController
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    unless line_bot_client.validate_signature(body, signature)
      head :bad_request
      return
    end

    events = line_bot_client.parse_events_from(body)
    events.each { |event| process_event(event) }

    head :ok
  end

  private

  def process_event(event)
    case event
    when Line::Bot::Event::Message
      handle_message_event(event)
    when Line::Bot::Event::Follow
      handle_follow_event(event)
    end
  end

  def line_bot_client
    @line_bot_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_MESSAGING_API_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def handle_follow_event(event)
    user_id = event['source']['userId']
    User.find_or_create_by(line_user_id: user_id)
    prompt_prefecture_message(event['replyToken'])
  end

  def prompt_prefecture_message(reply_token)
    message = {
      type: 'text',
      text: "登録ありがとうございます！都道府県を教えてください。例：東京都"
    }
    line_bot_client.reply_message(reply_token, message)
  end

  def handle_message_event(event)
    user_id = event['source']['userId']
    text = event.message['text'].strip
    handle_user_prefecture_input(text, user_id, event['replyToken'])
  end

  def handle_user_prefecture_input(text, user_id, reply_token)
    user = User.find_by(line_user_id: user_id)
    if PREFECTURES.include?(text)
      user.update(prefecture: text)
      reply_message(reply_token, "都道府県を「#{text}」として登録しました。")
    else
      reply_message(reply_token, "都道府県名が正しくありません。もう一度入力してください。")
    end
  end

  def reply_message(reply_token, text)
    message = { type: 'text', text: text }
    line_bot_client.reply_message(reply_token, message)
  end
end
