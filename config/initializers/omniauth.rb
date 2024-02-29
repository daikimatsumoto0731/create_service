Rails.application.config.middleware.use OmniAuth::Builder do
  provider :line, ENV['LINE_CHANNEL_ID'], ENV['LINE_CHANNEL_SECRET'], callback_url: 'https://vegetable_service.com/users/auth/line/callback'
end