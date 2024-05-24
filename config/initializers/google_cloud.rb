# config/initializers/google_cloud.rb

if ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']
  require 'tempfile'
  temp_file = Tempfile.new('google_application_credentials')
  temp_file.write(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
  temp_file.rewind
  ENV['GOOGLE_APPLICATION_CREDENTIALS'] = temp_file.path
  Rails.logger.info "Temporary credentials file created at: #{temp_file.path}"
else
  Rails.logger.error "GOOGLE_APPLICATION_CREDENTIALS_JSON is not set."
end
  