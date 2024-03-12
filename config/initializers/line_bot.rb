require 'line/bot'

# LINE Botの設定
Rails.application.config.line_bot_client = Line::Bot::Client.new do |config|
  config.channel_secret = ENV['LINE_MESSAGING_API_CHANNEL_SECRET']
  config.channel_token = ENV['LINE_CHANNEL_TOKEN']
end
