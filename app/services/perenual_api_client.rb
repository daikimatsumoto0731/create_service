# app/services/perenual_api_client.rb

require 'net/http'
require 'uri'
require 'json'

class PerenualApiClient
  BASE_URL = "https://perenual.com/api"

  def self.api_key
    ENV['PERENUAL_API_KEY'] || raise('PERENUAL_API_KEY is not set')
  end

  def self.fetch_species_care_guide(vegetable_name = nil)
    query_param = vegetable_name ? "&q=#{URI.encode_www_form_component(vegetable_name)}" : ""
    url = "#{BASE_URL}/species-care-guide-list?key=#{api_key}#{query_param}"
    uri = URI(url)

    Rails.logger.info "Fetching care guide with URL: #{url}"
    response = Net::HTTP.get_response(uri)

    handle_response(response)
  end

  private

  def self.handle_response(response)
    case response
    when Net::HTTPSuccess
      begin
        care_guide = JSON.parse(response.body)
        Rails.logger.info "Care guide fetched successfully: #{care_guide}"

        if care_guide['data']
          Rails.logger.info "Data present in care guide: #{care_guide['data']}"
        else
          Rails.logger.error "No 'data' key in care_guide: #{care_guide}"
        end

        care_guide
      rescue JSON::ParserError => e
        log_error("JSON parsing error: #{e.message}")
        nil
      end
    else
      log_error("HTTP Error: #{response.code} - #{response.message}, Body: #{response.body}")
      nil
    end
  end

  def self.log_error(message)
    Rails.logger.error message
  end
end