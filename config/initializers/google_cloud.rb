# config/initializers/google_cloud.rb

if ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON']
  require 'tempfile'
  begin
    temp_file = Tempfile.new('google_application_credentials')
    temp_file.write(ENV['GOOGLE_APPLICATION_CREDENTIALS_JSON'])
    temp_file.rewind
    ENV['GOOGLE_APPLICATION_CREDENTIALS'] = temp_file.path
    Rails.logger.info "Temporary credentials file created at: #{temp_file.path}"
  rescue StandardError => e
    Rails.logger.error "Failed to create temporary credentials file: #{e.message}"
  end
else
  Rails.logger.error "GOOGLE_APPLICATIONS_CREDENTIALS_JSON is not set."
end
  