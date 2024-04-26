# frozen_string_literal: true

class LineBotController < ApplicationController
  protect_from_forgery with: :null_session

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      return head :bad_request
    end

    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Follow
        handle_follow_event(event)
      end
    end

    head :ok
  end

  private

  def handle_follow_event(event)
    user_id = event['source']['userId']
    User.find_or_create_by(line_user_id: user_id) do |user|
      user.line_notification_setting ||= user.build_line_notification_setting(receive_notifications: true)
      user.save!
    end
  end

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_MESSAGING_API_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
