require 'google/cloud/vision'

Google::Cloud::Vision.configure do |config|
  config.credentials = JSON.parse(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
end
